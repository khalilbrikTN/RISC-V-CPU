`timescale 1ns / 1ps

module RISCV (
    input clk,
    input pb_clk,
    input rst,
    input [1:0] led_sel,
    input [3:0] ssd_sel,
    output [15:0] leds,
    output [3:0] anode,
    output [6:0] led_out,
    output [3:0] disable_anodes
);
endmodule
