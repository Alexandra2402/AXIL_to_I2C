`include "I2C_define.sv"
`include "AXIL_define.sv"

module AXI_I2C //#
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
    input logic aclk,
    input logic aresetn,
    //AXI intarface
	input  wire 										s_axi_aclk,
	input  wire											s_axi_aresetn,		
	(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_CTRL AWADDR" *)
	input  wire [`C_S_AXI_ADDR_WIDTH-1 : 0] 			    s_axi_awaddr,
	(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_CTRL AWPROT" *)
	input  wire [2 : 0] 						        s_axi_awprot,
	(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_CTRL AWVALID" *)
	input  wire  							            s_axi_awvalid,
	(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_CTRL AWREADY" *)
	output wire  							            s_axi_awready,
	(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_CTRL WDATA" *)
	input  wire [`C_S_AXI_DATA_WIDTH-1 : 0] 			    s_axi_wdata,
	(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_CTRL WSTRB" *)
	input  wire [(`C_S_AXI_DATA_WIDTH/8)-1 : 0] 		    s_axi_wstrb,
	(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_CTRL WVALID" *)
	input  wire  							            s_axi_wvalid,
	(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_CTRL WREADY" *)
	output wire  							            s_axi_wready,
	(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_CTRL BRESP" *)
	output wire [1 : 0] 					            s_axi_bresp,
	(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_CTRL BVALID" *)
	output wire  							            s_axi_bvalid,
	(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_CTRL BREADY" *)
	input  wire  							            s_axi_bready,
	(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_CTRL ARADDR" *)
	input  wire [`C_S_AXI_ADDR_WIDTH-1 : 0] 			    s_axi_araddr,
	(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_CTRL ARPROT" *)
	input  wire [2 : 0] 						        s_axi_arprot,
	(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_CTRL ARVALID" *)
	input  wire  							            s_axi_arvalid,
	(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_CTRL ARREADY" *)
	output wire  							            s_axi_arready,
	(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_CTRL RDATA" *)
	output wire [`C_S_AXI_DATA_WIDTH-1 : 0] 			    s_axi_rdata,
	(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_CTRL RRESP" *)
	output wire [1 : 0] 					            s_axi_rresp,
	(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_CTRL RVALID" *)
	output wire  							            s_axi_rvalid,
	(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_CTRL RREADY" *)
	input  wire  							            s_axi_rready
);


AXI_I2C_top axi_i2c_i (
    //I2C interface
    .SIO_C(SIO_C),
    .SIO_D(SIO_D),
    .aclk(aclk),
    .aresetn(aresetn),
    //AXIL interface
    .S_AXI_ACLK(s_axi_aclk),
	.S_AXI_ARESETN(s_axi_aresetn),
	.S_AXI_AWADDR(s_axi_awaddr),
	.S_AXI_AWPROT(s_axi_awprot),
	.S_AXI_AWVALID(s_axi_awvalid),
	.S_AXI_AWREADY(s_axi_awready),
	.S_AXI_WDATA(s_axi_wdata),
	.S_AXI_WSTRB(s_axi_wstrb),
	.S_AXI_WVALID(s_axi_wvalid),
	.S_AXI_WREADY(s_axi_wready),
	.S_AXI_BRESP(s_axi_bresp),
	.S_AXI_BVALID(s_axi_bvalid),
	.S_AXI_BREADY(s_axi_bready),
	.S_AXI_ARADDR(s_axi_araddr),
	.S_AXI_ARPROT(s_axi_arprot),
	.S_AXI_ARVALID(s_axi_arvalid),
	.S_AXI_ARREADY(s_axi_arready),
	.S_AXI_RDATA(s_axi_rdata),
	.S_AXI_RRESP(s_axi_rresp),
	.S_AXI_RVALID(s_axi_rvalid),
	.S_AXI_RREADY(s_axi_rready)
);


endmodule
