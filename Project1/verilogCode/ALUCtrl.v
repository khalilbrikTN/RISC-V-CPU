module ALUCtrl (
    input [1:0] alu_op,
    input func7bit30,
    input [2:0] func3,
    output reg [3:0] alu_ctrl,
    output reg unsigned_signal
);

  always @(*) begin
    case (alu_op)
      2'b00: alu_ctrl = 4'b0010;
      2'b01: alu_ctrl = 4'b0110;
      2'b10:
      case ({
        func7bit30, func3
      })
        4'b0000: alu_ctrl = 4'b0010;  // add
        4'b1000: alu_ctrl = 4'b0110;  // sub
        4'b0111: alu_ctrl = 4'b0000;  // and
        4'b0110: alu_ctrl = 4'b0001;  // or
        4'b0001: alu_ctrl = 4'b0011;  // sll
        4'b0010: alu_ctrl = 4'b0100;  // slt
        4'b0011: alu_ctrl = 4'b0101;  // sltu
        4'b0100: alu_ctrl = 4'b0111;  // xor
        4'b0101: alu_ctrl = 4'b1000;  // srl
        4'b1101: alu_ctrl = 4'b1010;  // sra
        default: alu_ctrl = 4'b0000;
      endcase
      2'b11:
      case ({
        func3
      })
        3'b000: alu_ctrl = 4'b0010;  // addi
        3'b111: alu_ctrl = 4'b0000;  // andi
        3'b110: alu_ctrl = 4'b0001;  // ori
        3'b001: alu_ctrl = 4'b0011;  // slli
        3'b010: alu_ctrl = 4'b0100;  // slti
        3'b011: alu_ctrl = 4'b0101;  // sltui
        3'b100: alu_ctrl = 4'b0111;  // xori
        3'b101:
        case (func7bit30)
          1'b1: alu_ctrl = 4'b1010;
          1'b0: alu_ctrl = 4'b1000;
        endcase  // srli
        default: alu_ctrl = 4'b0000;
      endcase
      default: alu_ctrl = 4'b0000;
    endcase
    unsigned_signal = (({func3} == 3'b011) && (alu_op[1] == 1'b1)) | ((alu_op == 2'b01) && (func3 == 3'b011));

  end
endmodule
