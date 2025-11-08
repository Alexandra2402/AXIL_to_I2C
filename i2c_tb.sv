`timescale 1ns/1ps

`include "I2C_define.sv"

module i2c_tb();

logic aclk;
logic aresetn;
logic[`I2C_DATA_WIDTH-1:0] i2c_data_wr;
logic[`I2C_ADDR_WIDTH-1:0] i2c_subaddr;
logic[`I2C_ADDR_WIDTH-2:0] i2c_id;
logic trans_type; //rd = 1, wr = 0
logic trans_en; //start rd/wr transaction
logic [`I2C_DATA_WIDTH-1:0] i2c_data_rd;
logic SIO_C;
wire SIO_D;
logic finish;
logic [19:0] tb_message = 20'b01110111x10111101x0;
logic mes_enb;

event rstn_event;

I2C_module DUT (.*);

always begin
    #5 aclk = 1;
    #5 aclk = 0;
end

initial begin
    aresetn = 0;
    #15
    aresetn = 1;
    -> rstn_event;
end

assign SIO_D = (mes_enb) ? tb_message[19] : 1'bZ;

always @(posedge aclk) begin
    if (mes_enb)
        tb_message <= {tb_message[18:0],1'b0};
    // else
        // tb_message <= 'X;
end

initial begin
    wait (rstn_event.triggered);
    mes_enb = 0;
    #840
    mes_enb = 1;
    #200
    mes_enb = 0;
end

initial begin
    wait (rstn_event.triggered);
    i2c_id = 7'b1100011;
    i2c_subaddr = 8'h77;
    i2c_data_wr = 8'h88;
    trans_en = 1;
    trans_type = '0;
    #100
    trans_en = 0;
    i2c_data_wr = 0;
    #500
    // i2c_id = 7'h22;
    // i2c_subaddr = 8'h77;
    // i2c_data_wr = '0;
    // trans_en = '1;
    // trans_type = '0;
    // #100
    // trans_en = '0;
    // #500
    i2c_id = 7'b1100011;
    i2c_subaddr = 8'h77;
    // i2c_data_wr = 0;
    trans_en = 1;
    trans_type = 1;
    #350
    trans_en = '0;
end

endmodule