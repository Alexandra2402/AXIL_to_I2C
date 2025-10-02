timescale 1ns/1ps

`ifndef AXIL_TB_MODEL
`define AXIL_TB_MODEL

`include "AXIL_define.sv"
`include "AXIL_interface.sv"

class AXIL_model;
//signals
logic [C_S_AXI_DATA_WIDTH-1:0] read_data;
logic [C_S_AXI_DATA_WIDTH-1:0] write_data;
//interface
virtual AXIL_interface axil_int;

function new(virtual AXIL_interface axil_int);
    //init virtual interface
    this.axil_int = axil_int;
    $display("[%t] AXIL model : Initialized.", $time);
endfunction: new

//tasks
extern task reset();
extern task axil_read();
extern task axil_write();

endclass: AXIL_model

//READ OPERATION
task AXIL_model::axil_read (logic [C_S_AXI_ADDR_WIDTH-1:0] read_address);

    @posedge(axil_int.S_AXI_ACLK)
    

endtask: AXIL_read

//WRITE OPERATION
task AXIL_model::axil_write (logic [C_S_AXI_ADDR_WIDTH-1:0] write_address, logic [C_S_AXI_DATA_WIDTH-1:0] write_data);


endtask: AXIL_write

//RESET OPERATION
task AXIL_model::reset ();


endtask: reset


`endif
