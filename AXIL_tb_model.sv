`timescale 1ns/1ps

`ifndef AXIL_TB_MODEL
`define AXIL_TB_MODEL

`include "AXIL_define.sv"
`include "AXIL_interface.sv"

class AXIL_model;
//signals
logic [`C_S_AXI_DATA_WIDTH-1:0] read_data;
logic [`C_S_AXI_DATA_WIDTH-1:0] write_data;
//interface
virtual AXIL_interface axil_int;

function new(virtual AXIL_interface axil_int);
    //init virtual interface
    this.axil_int = axil_int;
    $display("[%t] AXIL model : Initialized.", $time);
endfunction : new

//tasks
extern task reset();
extern task axil_read(logic [`C_S_AXI_ADDR_WIDTH-1:0] read_address);
extern task axil_write(logic [`C_S_AXI_ADDR_WIDTH-1:0] write_address, logic [`C_S_AXI_DATA_WIDTH-1:0] write_data);

endclass : AXIL_model

//READ OPERATION
task AXIL_model::axil_read (logic [`C_S_AXI_ADDR_WIDTH-1:0] read_address);

    @posedge(axil_int.S_AXI_ACLK)
    axil_int.rd_state <= RD_START;

    forever begin 
        @posedge(axil_int.S_AXI_ACLK)
        case(axil_int.rd_state)
            RD_START: begin
                axil_int.S_AXI_ARVALID  <= '1;
                axil_int.S_AXI_ARADDR   <= read_address;
                axil_int.S_AXI_ARPROT   <= '1;
                axil_int.S_AXI_RREADY   <= '1;
                axil_int.rd_cnt_wait    <= RD_ARREADY_WAIT;
                axil_int.rd_state       <= RD_FINISH;
            end
            RD_FINISH:begin
                if(axil_int.S_AXI_ARREADY) begin
                    axil_int.S_AXI_ARVALID  <= '0;
                    axil_int.S_AXI_ARADDR   <= '0;
                    axil_int.rd_cnt_wait    <= RD_RVALID_WAIT;
                    axil_int.rd_state       <= RD_DATA;
                end
                else begin
                    if (axil_int.rd_cnt_wait !=0)
                        axil_int.rd_cnt_wait <= axil_int.rd_cnt_wait -1;
                    else begin
                        $display("[%t] AXIL model : S_AXI_ARREADY TIme-Out", $time);
                        #100;
                        $stop;
                    end
                end

            end
            RD_DATA: begin
                if(axil_int.S_AXI_RVALID) begin
                    axil_int.S_AXI_RREADY   <= '0;
                    axil_int.S_AXI_ARADDR   <= '0;
                    read_data = axil.S_AXI_RDATA;
                    $display("READ TRANSACTION COMPLETE: ADDR = %d DATA = %d", read_address, read_data);
                end
                else begin
                    if (axil_int.rd_cnt_wait !=0)
                        axil_int.rd_cnt_wait <= axil_int.rd_cnt_wait -1;
                    else begin
                        $display("[%t] AXIL model : S_AXI_RVALID TIme-Out", $time);
                        #100;
                        $stop;
                    end
                end
            end
        endcase

    end

endtask: AXIL_read

//WRITE OPERATION
task AXIL_model::axil_write (logic [C_S_AXI_ADDR_WIDTH-1:0] write_address, logic [C_S_AXI_DATA_WIDTH-1:0] write_data);
    
    @posedge(axil_int.S_AXI_ACLK)
    axil_int.wr_state <= WR_START;

    forever begin
    @posedge(axil_int.S_AXI_ACLK)
    case(axil_int.wr_state)
        WR_START: begin
            axil_int.S_AXI_AWVALID  <= '1;
            axil_int.S_AXI_WVALID   <= '1;
            axil_int.S_AXI_AWADDR   <= write_address;
            axil_int.S_AXI_WDATA    <= write_data;
            axil_int.S_AXI_BREADY   <= '1;
            axil_int.S_AXI_WSTRB    <= 8'hFF;
            axil_int.S_AXI_AWPROT   <= '1;
            axil_int.wr_state       <= WR_FINISH;
            axil_int.wr_cnt_wait    <= WR_READY_WAIT;
        end
        WR_FINISH: begin
            if (axil_int.S_AXI_AWREADY & axil_int.S_AXI_WREADY) begin
                axil_int.S_AXI_AWVALID  <= '0;
                axil_int.S_AXI_WVALID   <= '0;
                axil_int.S_AXI_AWADDR   <= '0;
                axil_int.S_AXI_WDATA    <= '0;
                axil_int.S_AXI_WSTRB    <= 8'h00;
                axil_int.S_AXI_AWPROT   <= '0;
                axil_int.wr_state       <= WR_RESP;
                axil_int.wr_cnt_wait    <= WR_BVALID_WAIT;
            end
            else begin
                if (axil_int.wr_cnt_wait !=0)
                    axil_int.wr_cnt_wait <= axil_int.wr_cnt_wait -1;
                else begin
                    $display("[%t] AXIL model : S_AXI_AWREADY & S_AXI_WREADY TIme-Out", $time);
                    #100;
                    $stop;
                end
            end
        end
        WR_RESP: begin
            if(axil_int.S_AXI_BVALID) begin
                axil_int.S_AXI_BREADY   <= '0;
                $display("WRITE TRANSACTION COMPLETE: ADDR = %d DATA = %d", read_address, read_data);
            end
            else begin
                if (axil_int.wr_cnt_wait !=0)
                    axil_int.wr_cnt_wait <= axil_int.wr_cnt_wait -1;
                else begin
                    $display("[%t] AXIL model : S_AXI_BVALID TIme-Out", $time);
                    #100;
                    $stop;
                end
            end
        end

    endcase

    end

endtask: AXIL_write

//RESET OPERATION
task AXIL_model::reset ();

    @posedge(axil_int.S_AXI_ACLK)

    axil_int.S_AXI_ARADDR   <= '0;
    axil_int.S_AXI_ARPROT   <= '0;
    axil_int.S_AXI_RREADY   <= '0;
    axil_int.S_AXI_ARVALID  <= '0;

    axil_int.S_AXI_AWVALID  <= '0;
    axil_int.S_AXI_WVALID   <= '0;
    axil_int.S_AXI_AWADDR   <= '0;
    axil_int.S_AXI_WDATA    <= '0;
    axil_int.S_AXI_BREADY   <= '0;
    axil_int.S_AXI_WSTRB    <= '0;
    axil_int.S_AXI_AWPROT   <= '0;

    $display("[%t] AXIL model : RESET done!",$time);

endtask: reset


`endif
