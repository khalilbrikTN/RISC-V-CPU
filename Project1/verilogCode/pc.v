`timescale 1ns / 1ps

module pc (
    input clk,
    input rst,
    input [31:0] immediate,
    input branch_sel,
    input [1:0] jump,
    input [31:0] alu_result,
    output reg [7:0] counter
);
  wire [31:0] if_branch;
  assign if_branch = counter + immediate * 2'd2;
  always @(posedge clk or posedge rst) begin
    if (rst == 1) begin
      counter <= 0;
    end else if (counter < 100) begin
      if (branch_sel) begin
        counter <= if_branch;
      end else if (jump == 2'b11) begin
        counter <= counter + immediate;
      end else if (jump == 2'b01) begin
        counter <= alu_result;
      end else begin
        counter <= counter + 10'd4;
      end
    end else begin
      counter <= 10'd128;
    end
  end
endmodule
