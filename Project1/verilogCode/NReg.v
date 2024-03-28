`include "../../sources_1/new/DFlipFlop.v"

`timescale 1ns / 1ps

module NReg #(
    parameter N = 8
) (
    input load,
    input clk,
    input rst,
    input [N-1:0] in,
    output [N-1:0] out
);
  genvar i;
  generate
    for (i = 0; i < N; i = i + 1) begin : g_dflipflop
      wire din;
      Mux #(
          .N(1)
      ) MUX (
          .in0(out[i]),
          .in1(in[i]),
          .sel(load),
          .out(din)
      );
      DFlipFlop DFF (
          .clk(clk),
          .rst(rst),
          .D  (din),
          .Q  (out[i])
      );
    end
  endgenerate
endmodule
