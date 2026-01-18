`timescale 1ns/1ps

`include "AXIL_define.sv"
`include "AXIL_interface.sv"
`include "AXIL_tb_model.sv"

`include "I2C_define.sv"
`include "I2C_interface.sv"
`include "I2C_tb_model.sv"

// `include "AXI_I2C.sv"

module AXIL_to_I2C_module_tb();

    //axi lite
    logic s_axi_aclk = 0;
    logic s_axi_aresetn;
    logic [3:0] s_axi_awaddr;
    logic [2:0] s_axi_awprot;
    logic s_axi_awvalid;
    logic s_axi_awready;
    logic [31:0] s_axi_wdata;
    logic [3:0] s_axi_wstrb;
    logic s_axi_wvalid;
    logic s_axi_wready;
    logic [1:0] s_axi_bresp;
    logic s_axi_bvalid;
    logic s_axi_bready;
    logic [3:0] s_axi_araddr;
    logic [2:0] s_axi_arprot;
    logic s_axi_arvalid;
    logic s_axi_arready;
    logic [31:0] s_axi_rdata;
    logic [1:0] s_axi_rresp;
    logic s_axi_rvalid;
    logic s_axi_rready;

    logic SIO_C;
    wire SIO_D;
    logic aclk = 0;
    logic aresetn;

    // logic [6:0] i2c_id;
    // logic [7:0] i2c_subaddr;
    // logic [7:0] i2c_data_wr;
    // logic trans_en;
    // logic trans_type;
    // logic finish;
    // logic [7:0] i2c_data_rd;


    AXIL_interface axil_int();
    AXIL_model axil_mod;

    I2C_interface i2c_int();
    I2C_model i2c_mod;

    localparam AXI_CLK_PERIOD = 10;
    always #(AXI_CLK_PERIOD/2) s_axi_aclk=~s_axi_aclk;

    localparam aclk_period = 25;
    always #(aclk_period/2) aclk=~aclk;

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

    assign i2c_int.SIO_C            =   SIO_C;
    // assign SIO_D                    =   i2c_int.SIO_D;

    // AXIL_module 
    //     DUT (
    //         .i2c_id(i2c_id),
    //         .i2c_subaddr(i2c_subaddr),
    //         .i2c_data_wr(i2c_data_wr),
    //         .trans_en(trans_en),
    //         .trans_type(trans_type),
    //         .finish(finish),
    //         .i2c_data_rd(i2c_data_rd),
    //         .S_AXI_ACLK(s_axi_aclk),
    //         .S_AXI_ARESETN(s_axi_aresetn),
    //         .S_AXI_AWADDR(s_axi_awaddr),
    //         .S_AXI_AWPROT(s_axi_awprot),
    //         .S_AXI_AWVALID(s_axi_awvalid),
    //         .S_AXI_AWREADY(s_axi_awready),
    //         .S_AXI_WDATA(s_axi_wdata),
    //         .S_AXI_WSTRB(s_axi_wstrb),
    //         .S_AXI_WVALID(s_axi_wvalid),
    //         .S_AXI_WREADY(s_axi_wready),
    //         .S_AXI_BRESP(s_axi_bresp),
    //         .S_AXI_BVALID(s_axi_bvalid),
    //         .S_AXI_BREADY(s_axi_bready),
    //         .S_AXI_ARADDR(s_axi_araddr),
    //         .S_AXI_ARPROT(s_axi_arprot),
    //         .S_AXI_ARVALID(s_axi_arvalid),
    //         .S_AXI_ARREADY(s_axi_arready),
    //         .S_AXI_RDATA(s_axi_rdata),
    //         .S_AXI_RRESP(s_axi_rresp),
    //         .S_AXI_RVALID(s_axi_rvalid),
    //         .S_AXI_RREADY(s_axi_rready)
    // );

    AXI_SCCB_top
        DUT (
            .SIO_C(SIO_C),
            .SIO_D(i2c_int.SIO_D),
            .clk_40(aclk),
            .aresetn(aresetn),
            .S_AXI_ACLK(axil_int.S_AXI_ACLK),
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

    /**********AXIL CHECK only******************/
    // initial begin
    //     axil_mod = new(axil_int);
    //     s_axi_aresetn = 0;
    //     #1000
    //     s_axi_aresetn = 1;
    //     #100
    //     repeat(10)
    //         AXIL_compare_results($urandom_range(3,0), $urandom_range(31,0));
    //     $display("AXIL WRITE/READ TRANSACTION SUCCESS");
    //     $stop;
    // end
    /******************************************/

    logic trans_en;
    logic trans_type;
    logic [6:0] i2c_id;
    logic [7:0] i2c_subaddr;
    logic [7:0] i2c_data_wr;
    logic [31:0] wr_data;
    logic [3:0] addr;
    int i;

    initial begin
        axil_mod = new(axil_int);
        s_axi_aresetn = 0;
        aresetn = 0;
        #100
        s_axi_aresetn = 1;
        aresetn = 1;
        #100
        addr = 0;
        repeat(128) begin //wr operation check
            i2c_id = $urandom_range(127,0);
            i2c_subaddr = $urandom_range(255,0);
            i2c_data_wr = $urandom_range(255,0);
            // i2c_id = 7'b1100011;
            // i2c_subaddr = 8'b00111100;
            // i2c_data_wr = 8'b10100101;
            trans_en = 1;
            trans_type = 0; //wr - 0; rd - 1
            // AXIL_compare_results(0, {trans_en,trans_type,i2c_id,i2c_subaddr,i2c_data_wr,7'b0000000});
            wr_data = {trans_en,trans_type,i2c_id,i2c_subaddr,i2c_data_wr,7'b0000000};
            axil_mod.axil_write(0, wr_data);
            $display("WRITE TO I2C SLAVE");
            #500
            for (i = 0; i < 10000; i++) begin
                axil_mod.axil_read(0);
                if (axil_mod.read_data[6] == 1)
                    break;
                else if (i == 9999) begin
                    $display("WRITE FINISH RESPONSE ERROR");
                    $stop;
                end
            end
            // if (i2c_mod.wr_ready == 1) begin
                trans_type = 1;
                wr_data = {trans_en,1'b1,i2c_id,i2c_subaddr,8'b0000000,7'b0000000};
                axil_mod.axil_write(addr, wr_data);
                $display("READ FROM I2C SLAVE");
            // end
            for (i = 0; i < 10000; i++) begin
                axil_mod.axil_read(0);
                if (axil_mod.read_data[6] == 1)
                    break;
                else if (i == 9999) begin
                    $display("READ FINISH RESPONSE ERROR");
                    $stop;
                end
            end    
            // if (i2c_mod.rd_ready == 1) begin
                    axil_mod.axil_read(addr);
                if(axil_mod.read_data[14:7] != i2c_data_wr) begin
                    $display("AXIL WRITE/READ TRANSACTION FAILED");
                    $display("AXIL WRITE DATA = %d READ DATA = %d", i2c_data_wr, axil_mod.read_data[14:7]);
                    $stop;
                end
            // end
        end
        $display("AXI_I2C WRITE/READ TRANSACTION SUCCESS");
        $stop;
    end

    initial begin
        i2c_mod = new(i2c_int);
        i2c_mod.I2C_read_write();
    end

    // task AXIL_compare_results(logic [`C_S_AXI_ADDR_WIDTH-1:0] addr,
    //                             logic [`C_S_AXI_DATA_WIDTH-1:0] wr_data);
    //     axil_mod.axil_write(addr, wr_data);
    //     #5000
    //     if (i2c_mod.ready == 1) begin
    //         axil_mod.axil_read(addr);
    //         if(axil_mod.read_data != wr_data) begin
    //             $display("AXIL WRITE/READ TRANSACTION FAILED");
    //             $display("AXIL WRITE DATA = %d READ DATA = %d", wr_data, axil_mod.read_data);
    //             $stop;
    //         end  
    //     end
    // endtask

    // **********AXIL CHECK only******************//
    // task AXIL_compare_results(logic [`C_S_AXI_ADDR_WIDTH-1:0] addr,
    //                             logic [`C_S_AXI_DATA_WIDTH-1:0] wr_data);
    //     axil_mod.axil_write(addr, wr_data);
    //     #100
    //     axil_mod.axil_read(addr);
    //     if(axil_mod.read_data != wr_data) begin
    //         $display("AXIL WRITE/READ TRANSACTION FAILED");
    //         $display("AXIL WRITE DATA = %d READ DATA = %d", wr_data, axil_mod.read_data);
    //         $stop;
    //     end  
    //     end
    // endtask

endmodule