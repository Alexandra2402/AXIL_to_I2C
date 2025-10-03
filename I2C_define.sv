`ifndef I2C_DEFINE
`define I2C_DEFINE

`define I2C_DATA_WIDTH 8
`define I2C_ADDR_WIDTH 8

typedef enum {PHASE_INIT, PHASE_SEND, PHASE_RECIEVE, PHASE_FINISH} I2C_phase_state_type;

`endif