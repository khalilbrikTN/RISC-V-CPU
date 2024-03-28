`include "../../sources_1/new/FullAdder.v"

`timescale 1ns / 1ps

module RCA #(
    parameter n = 8
) (
    input  [n-1:0] a,
    input  [n-1:0] b,
    output [n-1:0] sum
);
  wire [n:0] C;

  genvar i;
  generate
    for (i = 0; i < n; i = i + 1) begin : g_FA_instance
      FullAdder FA_inst (
          .a(a[i]),
          .b(b[i]),
          .cin(i == 0 ? 1'b0 : C[i-1]),
          .sum(sum[i]),
          .carry(C[i])
      );
    end
  endgenerate

endmodule
