`timescale 1ns/1ps

`ifndef I2C_TB_MODEL
`define I2C_TB_MODEL

`include "I2C_define.sv"
`include "I2C_interface.sv"

class I2C_model;

logic [] data_wr;
logic [] i2c_ip;
logic [] i2c_subaddr;
logic trans_en;
logic trans_type;

virtual I2C_interface i2c_int;

function new(virtual I2C_interface i2c_int);
    this.i2c_int = i2c_int;
    $display("[%t] I2C model : Initialized.", $time);
endfunction : new

extern task reset();
extern task I2C_write(logic [`I2C_DATA_WIDTH-1:0] write_data, logic [`I2C_ADDR_WIDTH-2:0] i2c_id, logic [`I2C_ADDR_WIDTH-1:0] subaddr);
extern task I2C_read(logic [`I2C_ADDR_WIDTH-2:0] i2c_id, logic [`I2C_ADDR_WIDTH-1:0] subaddr);

endclass : I2C_model

task I2C_model::reset ();



    $display("[%t] I2C model : RESET done!",$time);

endtask: reset

//WRITE OPERATION
task I2C_model:: I2C_write(logic [`I2C_DATA_WIDTH-1:0] write_data, logic [`I2C_ADDR_WIDTH-2:0] i2c_id, logic [`I2C_ADDR_WIDTH-1:0] subaddr);

forever begin
    
end

endtask :I2C_write

`endif