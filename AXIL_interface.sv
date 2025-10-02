`ifndef AXIL_INTERFACE
`define AXIL_INTERFACE

`include "AXIL_define.sv"

interface AXIL_interface;

    // Global Clock Signal
    logic  S_AXI_ACLK;
    // Global Reset Signal. This Signal is Active LOW
    logic  S_AXI_ARESETN;
    // Write address (issued by master, acceped by Slave)
    logic [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR;
    // Write channel Protection type. This signal indicates the
        // privilege and security level of the transaction, and whether
        // the transaction is a data access or an instruction access.
    logic [2 : 0] S_AXI_AWPROT;
    // Write address valid. This signal indicates that the master signaling
        // valid write address and control information.
    logic  S_AXI_AWVALID;
    // Write address ready. This signal indicates that the slave is ready
        // to accept an address and associated control signals.
    logic  S_AXI_AWREADY;
    // Write data (issued by master, acceped by Slave) 
    logic [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA;
    // Write strobes. This signal indicates which byte lanes hold
        // valid data. There is one write strobe bit for each eight
        // bits of the write data bus.    
    logic [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB;
    // Write valid. This signal indicates that valid write
        // data and strobes are available.
    logic  S_AXI_WVALID;
    // Write ready. This signal indicates that the slave
        // can accept the write data.
    logic  S_AXI_WREADY;
    // Write response. This signal indicates the status
        // of the write transaction.
    logic [1 : 0] S_AXI_BRESP;
    // Write response valid. This signal indicates that the channel
        // is signaling a valid write response.
    logic  S_AXI_BVALID;
    // Response ready. This signal indicates that the master
        // can accept a write response.
    logic  S_AXI_BREADY;
    // Read address (issued by master, acceped by Slave)
    logic [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR;
    // Protection type. This signal indicates the privilege
        // and security level of the transaction, and whether the
        // transaction is a data access or an instruction access.
    logic [2 : 0] S_AXI_ARPROT;
    // Read address valid. This signal indicates that the channel
        // is signaling valid read address and control information.
    logic  S_AXI_ARVALID;
    // Read address ready. This signal indicates that the slave is
        // ready to accept an address and associated control signals.
    logic  S_AXI_ARREADY;
    // Read data (issued by slave)
    logic [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA;
    // Read response. This signal indicates the status of the
        // read transfer.
    logic [1 : 0] S_AXI_RRESP;
    // Read valid. This signal indicates that the channel is
        // signaling the required read data.
    logic  S_AXI_RVALID;
    // Read ready. This signal indicates that the master can
        // accept the read data and response information.
    logic  S_AXI_RREADY;


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