module ShiftLeft1 #(
    parameter n = 32
) (
    input  [n-1:0] a,
    output [n-1:0] b
);
  assign b[0] = 1'b0;
  assign b[n-1:1] = a[n-2:0];
endmodule
