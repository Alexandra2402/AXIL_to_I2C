`timescale 1ns/1ps

`include "AXIL_define.sv"
`include "AXIL_interface.sv"
`include "AXIL_module.sv"
`include "AXIL_tb_model.sv"

module AXIL_to_I2C_module_tb

    //axi lite
    logic s_axi_aclk;
    logic s_axi_aresetn;
    logic [3:0]s_axi_awaddr;
    logic [2:0]s_axi_awprot;
    logic s_axi_awvalid;
    logic s_axi_awready;
    logic [31:0]s_axi_wdata;
    logic [3:0]s_axi_wstrb;
    logic s_axi_wvalid;
    logic s_axi_wready;
    logic [1:0]s_axi_bresp;
    logic s_axi_bvalid;
    logic s_axi_bready;
    logic [3:0]s_axi_araddr;
    logic [2:0]s_axi_arprot;
    logic s_axi_arvalid;
    logic s_axi_arready;
    logic [31:0]s_axi_rdata;
    logic [1:0]s_axi_rresp;
    logic s_axi_rvalid;
    logic s_axi_rready;

    AXIL_interface axil_int();
    AXIL_model axil_mod;

    localparam AXI_CLK_PERIOD = 10;
    always #(AXI_CLK_PERIOD/2) s_axi_aclk=~s_axi_aclk;

    assign axil_int.S_AXI_ACLK 	    =   s_axi_aclk;
    assign axil_int.S_AXI_ARESETN 	=   s_axi_aresetn;
    assign s_axi_awaddr 			=   axil_int.S_AXI_AWADDR;
    assign s_axi_awprot 			=   axil_int.S_AXI_AWPROT;
    assign s_axi_awvalid 			=   axil_int.S_AXI_AWVALID;
    assign axil_int.S_AXI_AWREADY 	=   s_axi_awready;
    assign s_axi_wdata 				=   axil_int.S_AXI_WDATA;
    assign s_axi_wstrb 				=   axil_int.S_AXI_WSTRB;
    assign s_axi_wvalid 			=   axil_int.S_AXI_WVALID;
    assign axil_int.S_AXI_WREADY 	=   s_axi_wready;
    assign axil_int.S_AXI_BRESP 	=   s_axi_bresp;
    assign axil_int.S_AXI_BVALID 	=   s_axi_bvalid;
    assign s_axi_bready 			=   axil_int.S_AXI_BREADY;
    assign s_axi_araddr 			=   axil_int.S_AXI_ARADDR;
    assign s_axi_arprot 			=   axil_int.S_AXI_ARPROT;
    assign s_axi_arvalid 			=   axil_int.S_AXI_ARVALID;
    assign axil_int.S_AXI_ARREADY 	=   s_axi_arready;
    assign axil_int.S_AXI_RDATA 	=   s_axi_rdata;
    assign axil_int.S_AXI_RRESP 	=   s_axi_rresp;
    assign axil_int.S_AXI_RVALID 	=   s_axi_rvalid;
    assign s_axi_rready 			=   axil_int.S_AXI_RREADY;

    AXIL_module DUT 
        #(
            .C_S_AXI_DATA_WIDTH(`C_S_AXI_DATA_WIDTH),
            .C_S_AXI_ADDR_WIDTH(`C_S_AXI_ADDR_WIDTH)
        )
        (
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
    )

    initial begin
        axil_mod = new(axil_int);
        s_axi_aresetn = 0;
        #1000
        s_axi_aresetn = 1;
        repeat(100)
            AXIL_compare_results()
    end

    task AXIL_compare_results();

        rand logic ['C_S_AXI_ADDR_WIDTH-1:0] addr;
        rand logic [`C_S_AXI_DATA_WIDTH-1:0] wr_data;
        // logic [`C_S_AXI_DATA_WIDTH-1:0] rd_data;

        axil_mod.axil_write(addr, wr_data);
        #5000
        axil_mod.axil_read(addr);
        if(axil_mod.read_data == wr_data)
            $display("AXIL WRITE/READ TRANSACTION SUCCESS");
        else begin
            $display("AXIL WRITE/READ TRANSACTION FAILED");
            $stop;
        end

    endtask

endmodule