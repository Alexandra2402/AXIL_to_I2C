`include "I2C_define.sv"

module I2C_module 
// #(
//     parameter integer I2C_DATA_WIDTH = 8,
//     parameter integer I2C_ADDR_WIDTH = 8
// )
(
    output logic SIO_C,
    inout logic SIO_D,
    input logic aclk,
    input logic aresetn,
    input logic[`I2C_DATA_WIDTH-1:0] i2c_data_wr,
    input logic[`I2C_ADDR_WIDTH-1:0] i2c_subaddr,
    input logic[`I2C_ADDR_WIDTH-2:0] i2c_id,
    input logic trans_type, //rd = 1, wr = 0
    input logic trans_en, //start rd/wr transaction
    output logic [`I2C_DATA_WIDTH-1:0] i2c_data_rd,
    output logic finish
);

localparam WR_TRANS_WIDTH = 27;

logic [8:0] phase1_data;
logic [8:0] phase2_data;
logic [8:0] phase3_data;
logic rd_flag, wr_flag, receive_flag = 0;
logic [4:0] message_cntr;
logic [WR_TRANS_WIDTH+3:0] message;
logic wr_complete = 0;
logic rd_complete = 0;
logic receive_complete = 0;
logic [21:0] receive_reg;
logic flag_delay;
logic clk_flag_delay;
logic [1:0] clk_finish = '0;
logic clk_delay_out;

I2C_phase_state_type PHASE_state;
I2C_phase_state_type PHASE_state_next;

assign phase1_data = {i2c_id, trans_type, 1'bX};
assign phase2_data = {i2c_subaddr, 1'bX};
assign phase3_data = {i2c_data_wr, 1'bX};

assign SIO_D = (flag_delay ^ receive_flag) ? message[30] : 1'bZ;
// assign SIO_C = (clk_flag_delay) ? aclk : 1 ;
assign SIO_C = (clk_delay_out ~^ clk_flag_delay && clk_flag_delay == 1) ? aclk : 1 ;
// assign i2c_data_rd = (receive_complete) ? receive_reg[10:3] : 0;
assign i2c_data_rd = (clk_finish != 0) ? receive_reg[10:3] : 0;
assign finish = (clk_finish == 0) ? 0 : 1;
assign clk_flag_delay = wr_flag ? wr_flag ~^ flag_delay : rd_flag ? rd_flag ~^ flag_delay : receive_flag ? receive_flag ~^ flag_delay : 0;

always @(posedge aclk or negedge aresetn) begin
    if (PHASE_state == PHASE_FINISH)
        clk_finish <= clk_finish + 1;
    else clk_finish <= 0;
end

always_ff @(posedge aclk or negedge aresetn) begin
    if(!aresetn)
        PHASE_state <= PHASE_INIT;
    else PHASE_state <= PHASE_state_next;
end

always_ff @(posedge aclk or negedge aresetn) begin
    clk_delay_out <= clk_flag_delay;
end

always_comb begin 
        rd_flag = 0;
        wr_flag = 0;
        receive_flag = 0;
        PHASE_state_next = PHASE_state;
        case(PHASE_state) 
        PHASE_INIT: begin
            rd_flag = 0;
            wr_flag = 0;
            if(trans_en && trans_type) begin
                PHASE_state_next = PHASE_RD_SEND;
            end
            else if (trans_en && !trans_type)begin
                PHASE_state_next = PHASE_WR_SEND;
            end
        end
        PHASE_RD_SEND: begin
            PHASE_state_next = PHASE_RD_SEND; 
            rd_flag = 1;
            if(rd_complete) begin
                // rd_flag = 0;
                PHASE_state_next = PHASE_RECEIVE;
            end
        end
        PHASE_RECEIVE: begin
            rd_flag = 0;
            receive_flag = 1;
            if (receive_complete) begin
                PHASE_state_next = PHASE_FINISH;
                receive_flag = 0;
            end
        end
         PHASE_WR_SEND: begin
            wr_flag = 1;
            if(wr_complete)
                PHASE_state_next = PHASE_FINISH;
        end
        PHASE_FINISH: begin
                rd_flag = 0;
                wr_flag = 0;
                receive_flag = 0;
                if (clk_finish == 3)
                    PHASE_state_next = PHASE_INIT; 
        end
        endcase
end

always @(posedge aclk or negedge aresetn) begin
    if(!aresetn) 
        message_cntr <= 0;
    else begin
        if(rd_flag) begin
            if(message_cntr == 22)
                message_cntr <= 0;
            else
                message_cntr <= message_cntr + 1;
        end
        else if (receive_flag)begin
            if(message_cntr == 22)
                message_cntr <= 0;
            else
                message_cntr <= message_cntr + 1;
        end
        else if(wr_flag) begin
            if(message_cntr == 31)
                message_cntr <= 0;
            else
                message_cntr <= message_cntr + 1;
        end
        else message_cntr <= 0;
    end
end

always_ff @( posedge aclk ) begin
    if (rd_flag && message_cntr == 21)
        rd_complete <= 1;
    else rd_complete <= 0;
end

always_ff @(posedge aclk ) begin
    if (receive_flag && message_cntr == 20)
        receive_complete <= 1;
    else receive_complete <= 0;
end

always_ff @( posedge aclk ) begin
    if (wr_flag && message_cntr == 29)
        wr_complete <= 1;
    else wr_complete <= 0;
end

always @(posedge aclk) begin
    if (rd_flag) begin 
        if (message_cntr >= 1)
            message <= {message[29:0], 1'bz};
        else if (message_cntr == 0)
            message <= {1'b1,1'b0, phase1_data, phase2_data, 1'b0, 1'b1, 9'bzzzzzzzzz};
        else message <= 0;
    end
    if (wr_flag) begin 
        if (message_cntr >= 1) 
            message <= {message[29:0], 1'bz};
        else if (message_cntr == 0)
            message <= {1'b1, 1'b0, phase1_data, phase2_data, phase3_data, 1'b0, 1'b1};
        else message <= 0;
    end
end

always_ff @(negedge aclk or negedge aresetn ) begin 
    if (!aresetn)
        receive_reg <= 0;
    else begin
        if (receive_flag) begin 
            if (message_cntr >= 0) begin
                receive_reg[21-message_cntr] <= SIO_D;
            end
            else begin
                receive_reg <= 0;
            end
        end
    end
end

always_ff @( posedge aclk ) begin
    if (!aresetn)
        flag_delay <= 0;
    else begin
        if (wr_flag)
            flag_delay <= wr_flag;
        else if (rd_flag)
            flag_delay <= rd_flag;
        else if (receive_flag)
            flag_delay <= receive_flag;
        else flag_delay <= 0;
    end
end

endmodule
