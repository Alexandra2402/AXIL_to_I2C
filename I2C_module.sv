`include "I2C_define.sv"

module I2C_module #(
    parameter integer I2C_DATA_WIDTH = 8,
    parameter integer I2C_ADDR_WIDTH = 8
)
(
    input logic aclk,
    input logic aresetn,
    input logic[I2C_DATA_WIDTH-1:0] i2c_data_wr,
    input logic[I2C_ADDR_WIDTH-1:0] i2c_subaddr,
    input logic[I2C_ADDR_WIDTH-2:0] i2c_id,
    input logic trans_type, //rd = 1, wr = 0
    inout reg trans_en, //start rd/wr transaction
    // output logic [I2C_DATA_WIDTH-1:0] i2c_data_rd,
    output logic SIO_C,
    output logic SIO_D
);

// localparam IP_ADDR_WIDTH = 7;
localparam WR_TRANS_WIDTH = 27;

logic SIO_C_next;
logic SIO_D_next;
// logic [I2C_DATA_WIDTH-1:0] i2c_data_rd;
// logic [6:0] id_addr = 7'b1111111;
logic [WR_TRANS_WIDTH/3-1:0] phase1_data;
logic [WR_TRANS_WIDTH/3-1:0] phase2_data;
logic [WR_TRANS_WIDTH/3-1:0] phase3_data;
// logic [WR_TRANS_WIDTH-1:0] wr_transaction;
// logic [WR_TRANS_WIDTH/3*2-1:0] rd_addr_transaction;
// logic [WR_TRANS_WIDTH/3*2-1:0] rd_data_transaction;
logic rd_flag, wr_flag, recieve_flag;
logic [4:0] message_cntr;
logic [WR_TRANS_WIDTH-1:0] message;

I2C_phase_state_type PHASE_state;
I2C_phase_state_type PHASE_state_next;

assign phase1_data = {i2c_id, trans_type, 1'bX};
assign phase2_data = {i2c_subaddr, 1'bX};
assign phase3_data = {i2c_data_wr, 1'bX};

// assign wr_transaction = {phase1_data,phase2_data,phase3_data};
// assign rd_addr_transaction = {phase1_data,phase2_data};


always_ff @(posedge aclk or negedge aresetn)begin
    if(!aresetn) begin
        SIO_C <= '1;
        SIO_D <= '1;
        PHASE_state <= PHASE_INIT;
    end
    else begin
        SIO_C <= SIO_C_next;
        SIO_D <= SIO_D_next;
        PHASE_state <= PHASE_state_next;
    end

end

always begin
    if (trans_en) begin
        case(PHASE_state) 
        PHASE_INIT: begin
            message = '0;
            rd_flag = '0;
            wr_flag = '0;
            if(trans_type) begin
                PHASE_state_next = PHASE_RD_SEND;
            end
            else begin
                PHASE_state_next = PHASE_WR_SEND;
            end
        end
        PHASE_RD_SEND: begin
            if(recieve_flag) 
                PHASE_state_next = PHASE_RD_RECIEVE; 
            else begin
                PHASE_state_next = PHASE_RD_SEND; 
                rd_flag = '1;
                message = {phase1_data, phase2_data, 9'b000000000};
            end
        end
        PHASE_RD_RECIEVE: begin
            PHASE_state_next = PHASE_FINISH;
        end
        PHASE_WR_SEND: begin
            wr_flag = '1;
            message = {phase1_data, phase2_data, phase3_data};
            PHASE_state_next = PHASE_FINISH;
        end
        PHASE_FINISH: begin
            trans_en = '0;
            rd_flag = '0;
            wr_flag = '0;
            message = '0;
        end
        endcase
    end
end

always @(posedge aclk or negedge aresetn) begin
    if(!aresetn) 
        message_cntr <= '0;
    else begin
        if(rd_flag) begin
            if(message_cntr == 17)
                message_cntr <='0;
            else
                message_cntr <= message_cntr + 1;
        end
        else if(wr_flag) begin
            if(message_cntr == 26)
                message_cntr <='0;
            else
                message_cntr <= message_cntr + 1;
        end
    end
end



endmodule 