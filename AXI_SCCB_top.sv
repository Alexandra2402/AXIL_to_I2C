`include "I2C_define.sv"
`include "AXIL_define.sv"

module AXI_SCCB_top //#
// (
//     // Width of S_AXI data bus
//     parameter integer C_S_AXI_DATA_WIDTH	= 32,
//     // Width of S_AXI address bus
//     parameter integer C_S_AXI_ADDR_WIDTH	= 4
// )
(
    //I2C interface
    output logic SIO_C,
    inout wire SIO_D,
    input logic clk_40, //input clk = 40 MHz
    input logic aresetn,

    //AXI intarface
    // Global Clock Signal
    input wire  S_AXI_ACLK,
    // Global Reset Signal. This Signal is Active LOW
    input wire  S_AXI_ARESETN,
    // Write address (issued by master, acceped by Slave)
    input wire [`C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
    // Write channel Protection type. This signal indicates the
        // privilege and security level of the transaction, and whether
        // the transaction is a data access or an instruction access.
    input wire [2 : 0] S_AXI_AWPROT,
    // Write address valid. This signal indicates that the master signaling
        // valid write address and control information.
    input wire  S_AXI_AWVALID,
    // Write address ready. This signal indicates that the slave is ready
        // to accept an address and associated control signals.
    output wire  S_AXI_AWREADY,
    // Write data (issued by master, acceped by Slave) 
    input wire [`C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
    // Write strobes. This signal indicates which byte lanes hold
        // valid data. There is one write strobe bit for each eight
        // bits of the write data bus.    
    input wire [(`C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
    // Write valid. This signal indicates that valid write
        // data and strobes are available.
    input wire  S_AXI_WVALID,
    // Write ready. This signal indicates that the slave
        // can accept the write data.
    output wire  S_AXI_WREADY,
    // Write response. This signal indicates the status
        // of the write transaction.
    output wire [1 : 0] S_AXI_BRESP,
    // Write response valid. This signal indicates that the channel
        // is signaling a valid write response.
    output wire  S_AXI_BVALID,
    // Response ready. This signal indicates that the master
        // can accept a write response.
    input wire  S_AXI_BREADY,
    // Read address (issued by master, acceped by Slave)
    input wire [`C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
    // Protection type. This signal indicates the privilege
        // and security level of the transaction, and whether the
        // transaction is a data access or an instruction access.
    input wire [2 : 0] S_AXI_ARPROT,
    // Read address valid. This signal indicates that the channel
        // is signaling valid read address and control information.
    input wire  S_AXI_ARVALID,
    // Read address ready. This signal indicates that the slave is
        // ready to accept an address and associated control signals.
    output wire  S_AXI_ARREADY,
    // Read data (issued by slave)
    output wire [`C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
    // Read response. This signal indicates the status of the
        // read transfer.
    output wire [1 : 0] S_AXI_RRESP,
    // Read valid. This signal indicates that the channel is
        // signaling the required read data.
    output wire  S_AXI_RVALID,
    // Read ready. This signal indicates that the master can
        // accept the read data and response information.
    input wire  S_AXI_RREADY

);

logic[`I2C_DATA_WIDTH-1:0] i2c_data_wr;
logic[`I2C_ADDR_WIDTH-1:0] i2c_subaddr;
logic[`I2C_ADDR_WIDTH-2:0] i2c_id;
logic trans_type; //rd = 1, wr = 0
logic trans_en; //start rd/wr transaction
logic [`I2C_DATA_WIDTH-1:0] i2c_data_rd;
logic finish;
logic [5:0] clk_counter;
logic aclk;

always_ff @(posedge clk_40) begin // create internal clk = 400 kHz for I2C interface
    if (!aresetn) begin
        clk_counter <= 0;
        aclk <= 0;
    end
    else begin
        if (clk_counter == 49) begin
            clk_counter <= 0;
            aclk <= ~aclk;
        end
        else
            clk_counter <= clk_counter + 1;
    end
end  

AXIL_module DUT_axi (.*);

I2C_module DUT_i2c (.*);


endmodule
