`timescale 1ns / 1ps

module branch_ctrl (
    input [2:0] branch_op,
    input branch,
    input zf,
    input negative,
    output reg branch_sel
);


  always @(*) begin
    case (branch_op)
      3'b000:  if (branch) branch_sel = zf;
 else branch_sel = 1'b0;
      3'b001:  if (branch) branch_sel = ~zf;
 else branch_sel = 1'b0;
      3'b100:  if (branch) branch_sel = negative;
 else branch_sel = 1'b0;
      3'b101:  if (branch) branch_sel = ~negative;
 else branch_sel = 1'b0;
      3'b110:  if (branch) branch_sel = negative;
 else branch_sel = 1'b0;
      3'b111:  if (branch) branch_sel = ~negative;
 else branch_sel = 1'b0;
      default: branch_sel = 1'b0;
    endcase
  end


endmodule
