`ifndef AXIL_DEFINE
`define AXIL_DEFINE


`define C_S_AXI_DATA_WIDTH	= 32;
`define C_S_AXI_ADDR_WIDTH	= 4;

typedef enum {RD_START, RD_FINISH, RD_DATA} axil_rd_state_type;
typedef enum {} axil_wr_state_type;

`endif