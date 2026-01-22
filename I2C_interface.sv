`ifndef I2C_INTERFACE
`define I2C_INTERFACE

// `include "I2C_define.sv"

interface I2C_interface;

logic SIO_C;
wire SIO_D;
logic SIO_D_output;
logic SIO_D_input;
logic SIO_D_EN = 0;

assign SIO_D_input = ~SIO_D_EN ? SIO_D : 1'bz;
assign SIO_D = SIO_D_EN ? SIO_D_output : 1'bz;

modport slave(
    input SIO_C,
    inout SIO_D,
    output SIO_D_output,
    input SIO_D_input
);
endinterface

`endif