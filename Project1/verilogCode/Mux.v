`timescale 1ns / 1ps

module Mux #(
    parameter N = 8
) (
    input [N-1:0] in0,
    input [N-1:0] in1,
    input sel,
    output [N-1:0] out
);
  genvar i;
  generate
    for (i = 0; i < N; i = i + 1) begin : g_mux
      assign out[i] = sel ? in1[i] : in0[i];
    end
  endgenerate
endmodule
