`include "I2C_define.sv"

module I2C_module #(
    parameter integer I2C_DATA_WIDTH = 8,
    parameter integer I2C_ADDR_WIDTH = 8
)
(
    input logic aclk,
    input logic aresetn,
    input logic[I2C_DATA_WIDTH-1:0] i2c_data_wr,
    input logic[I2C_ADDR_WIDTH-1:0] i2c_addr,
    input logic trans_type, //rd = 1, wr = 0
    input logic trans_en, //start rd/wr transaction
    // output logic [I2C_DATA_WIDTH-1:0] i2c_data_rd,
    output logic SIO_C,
    output logic SIO_D
);

// localparam IP_ADDR_WIDTH = 7;
localparam WR_TRANS_WIDTH = 27;

logic SIO_C_next;
logic SIO_D_next;
// logic [I2C_DATA_WIDTH-1:0] i2c_data_rd;
logic [6:0] ip_addr = 7'b1111111;
logic [WR_TRANS_WIDTH/3-1:0] phase1_data;
logic [WR_TRANS_WIDTH/3-1:0] phase2_data;
logic [WR_TRANS_WIDTH/3-1:0] phase3_data;
logic [WR_TRANS_WIDTH-1:0] wr_transaction;
logic [WR_TRANS_WIDTH/3*2-1:0] rd_addr_transaction;
logic [WR_TRANS_WIDTH/3*2-1:0] rd_data_transaction;

I2C_phase_state_type PHASE_state;
I2C_phase_state_type PHASE_state_next;

assign phase1_data = {ip_addr, trans_type, 1'bX};
assign phase2_data = {i2c_addr, 1'bX};
assign phase3_data = {i2c_data_wr, 1'bX};

assign wr_transaction = {phase1_data,phase2_data,phase3_data};
assign rd_addr_transaction = {phase1_data,phase2_data};


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
            
        end
        PHASE_SEND: begin
            
        end
        PHASE_RECIEVE: begin
            
        end
        PHASE_FINISH: begin
            
        end
        endcase
    end
end




endmodule 