`timescale 1ns/1ps

`ifndef AXIL_INTERFACE
`define AXIL_INTERFACE

`include "AXIL_define.sv"

interface AXIL_interface;

    logic  S_AXI_ACLK;
    logic  S_AXI_ARESETN;
    logic [`C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR;
    logic [2 : 0] S_AXI_AWPROT;
    logic  S_AXI_AWVALID;
    logic  S_AXI_AWREADY;
    logic [`C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA;
    logic [(`C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB;
    logic  S_AXI_WVALID;
    logic  S_AXI_WREADY;
    logic [1 : 0] S_AXI_BRESP;
    logic  S_AXI_BVALID;
    logic  S_AXI_BREADY;
    logic [`C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR;
    logic [2 : 0] S_AXI_ARPROT;
    logic  S_AXI_ARVALID;
    logic  S_AXI_ARREADY;
    logic [`C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA;
    logic [1 : 0] S_AXI_RRESP;
    logic  S_AXI_RVALID;
    logic  S_AXI_RREADY;

    axil_rd_state_type rd_state;
    axil_wr_state_type wr_state;

    logic [31:0] rd_cnt_wait;
    logic [31:0] wr_cnt_wait;


    modport master (
        input S_AXI_ACLK,
        input S_AXI_ARESETN,
        output S_AXI_AWADDR,
        output S_AXI_AWPROT,
        output S_AXI_AWVALID,
        input S_AXI_AWREADY,
        output S_AXI_WDATA,
        output S_AXI_WSTRB,
        output S_AXI_WVALID,
        input S_AXI_WREADY,
        input S_AXI_BRESP,
        input S_AXI_BVALID,
        output S_AXI_BREADY,
        output S_AXI_ARADDR,
        output S_AXI_ARPROT,
        output S_AXI_ARVALID,
        input S_AXI_ARREADY,
        input S_AXI_RDATA,
        input S_AXI_RRESP,
        input S_AXI_RVALID,
        output S_AXI_RREADY
        );
    endinterface

`endif