`timescale 1ns / 1ps

module ImmGen (
    input [31:0] inst,
    output reg [31:0] gen_out
);
assign opcode = inst[6:0];
  always @* begin
    if (inst[31]) begin
      // Sign extension for negative immediate values
      gen_out = 32'b11111111111111111111111111111111;
    end
    else begin
      gen_out = 0;
    end

    if (inst[6:0] == 7'b1100011 ) begin
      // B-type instruction
      gen_out[10] = inst[7];
      gen_out[3:0] = inst[11:8];
      gen_out[9:4] = inst[30:25];
      gen_out[11]  = inst[31];
    end
    else if (opcode == 7'b0100011) begin
        // S-type instruction
        gen_out[11:5] = inst[31:25];
        gen_out[4:0]  = inst[11:7];
      end
      else if(opcode == 7'b1101111) begin
        // jump and link instruction
        gen_out[20] = inst[31];
        gen_out[10:1] = inst[30:21];
        gen_out[11] = inst[20];
        gen_out[19:12] = inst[19:12];
      end
      else if(opcode == 7'b1100111) begin
        // jump and link register instruction
        gen_out[11:0] = inst[31:20];
      end
      else begin
        // I intructions
        gen_out[11:0] = inst[31:20];
      end
    end

endmodule
