`ifndef AXIL_DEFINE
`define AXIL_DEFINE


`define C_S_AXI_DATA_WIDTH 32
`define C_S_AXI_ADDR_WIDTH 4

`define RD_ARREADY_WAIT 10000
`define RD_RVALID_WAIT 10000

`define WR_READY_WAIT 10000
`define WR_BVALID_WAIT 10000

typedef enum {RD_START, RD_FINISH, RD_DATA} axil_rd_state_type;
typedef enum {WR_START, WR_FINISH, WR_RESP} axil_wr_state_type;

`endif