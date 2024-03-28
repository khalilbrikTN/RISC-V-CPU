`timescale 1ns / 1ps

module ControlUnit (
    input [6:2] opcode,
    output reg Branch,
    MemRead,
    MemtoReg,
    MemWrite,
    ALUSrc,
    RegWrite,
    PassImm,  // This passes the immediate straight to the register file
    AUIPCSel,
    EnvironmentCall,
    output reg [1:0] ALUOp,
    output reg [1:0] jump
);
  // Default assignments
  always @* begin
    Branch   = 0;
    MemRead  = 0;
    MemtoReg = 0;
    MemWrite = 0;
    ALUSrc   = 0;
    RegWrite = 0;
    jump  = 2'b00;
    ALUOp    = 2'b00; // goes to alu ctrl
    PassImm = 0;
    AUIPCSel = 0;
    EnvironmentCall = 0;
    // Decode opcode
    case (opcode)
      5'b01100: begin  // R-Type
        RegWrite = 1;
        ALUOp    = 2'b10;
      end
      5'b00100: begin  // I-Type
        ALUSrc   = 1;
        RegWrite = 1;
        ALUOp    = 2'b11;
      end

      5'b00000: begin  // Load instructions
        MemRead  = 1;
        MemtoReg = 1;
        ALUSrc   = 1;
        RegWrite = 1;
        ALUOp    = 2'b00;
      end

      5'b01000: begin  // SW-Type
        MemWrite = 1;
        ALUSrc   = 1;
        ALUOp    = 2'b00;
      end

      5'b11000: begin  //Branch
        Branch = 1;
        ALUOp  = 2'b01;
      end
      5'b11001: begin  // JALR
        jump = 2'b01;
        ALUOp = 2'b11;
        ALUSrc = 1;
        RegWrite = 1;
      end
      5'b11011: begin  // JAL
        jump = 2'b11;
        RegWrite = 1;
      end
      5'b01101: begin  // LUI
        PassImm  = 1;
        RegWrite = 1;
      end
      5'b00101: begin  // AUIPC
        AUIPCSel = 1;
        ALUOp = 2'b00;
        ALUSrc = 1;
        RegWrite = 1;
      end
      5'b11100: begin  // ECALL and EBREAK
        EnvironmentCall = 1;
      end
      5'b00011: begin  // FENCE; currently empty but put it nontheless for potential future use
      end
    endcase
  end
endmodule
