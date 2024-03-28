`timescale 1ns / 1ps

module ALU #(
    parameter n = 32
) (
    input [n-1:0] rs1,
    input [n-1:0] rs2,
    input [3:0] alu_ctrl,
    input unsigned_signal,
    output reg [n-1:0] res,
    output reg zf,
    output reg neg
);

  wire [n-1:0] alu_rs1, alu_rs2;
  assign alu_rs1 = unsigned_signal ? (rs1[31] ? (~rs1 + 1) : rs1) : rs1;
  assign alu_rs2 = unsigned_signal ? (rs2[31] ? (~rs2 + 1) : rs2) : rs2;

  always @(*) begin
    case (alu_ctrl)
      4'b0010: res = (alu_rs1 + alu_rs2);
      4'b0110: res = (alu_rs1 - alu_rs2);
      4'b0000: res = (alu_rs1 & alu_rs2);
      4'b0001: res = (alu_rs1 | alu_rs2);
      4'b0011: res = (alu_rs1 << alu_rs2[4:0]);
      4'b0100: res = ($signed(alu_rs1) < $signed(alu_rs2));
      4'b0101: res = ($signed(alu_rs1) < $signed(alu_rs2));
      4'b0111: res = (alu_rs1 ^ alu_rs2);
      4'b1000: res = (alu_rs1 >> alu_rs2[4:0]);
      4'b1010: res = $signed($signed(alu_rs1) >>> $signed(alu_rs2[4:0]));
      default: res = 32'd0;
    endcase

    if (res == 0) zf = 1;
    else zf = 0;
    if (res[31] == 1) neg = 1;
    else neg = 0;

  end
endmodule
