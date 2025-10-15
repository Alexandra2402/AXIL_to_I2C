`ifndef I2C_DEFINE
`define I2C_DEFINE

`define I2C_DATA_WIDTH 8
`define I2C_ADDR_WIDTH 8

typedef enum {PHASE_INIT, PHASE_RD_SEND, PHASE_RD_RECIEVE, PHASE_WR_SEND, PHASE_FINISH} I2C_phase_state_type;

`endif