module DataMem (
    input clk,
    input MemRead,
    input MemWrite,
    input [5:0] addr,
    input [31:0] data_in,
    output reg [31:0] data_out
);
  reg [31:0] mem[63:0];
  initial begin
    mem[0]  = 32'd10;
    mem[1]  = 32'd1;
    mem[2]  = 32'd4;
    mem[3]  = 32'd16;
    mem[4]  = 32'd0;   // Memory location 4
    mem[5]  = 32'd0;   // Memory location 5
    mem[6]  = 32'd0;   // Memory location 6
    mem[7]  = 32'd0;   // Memory location 7
    mem[8]  = 32'd0;   // Memory location 8
    mem[9]  = 32'd0;   // Memory location 9
    mem[10] = 32'd0;   // Memory location 10
    mem[11] = 32'd0;   // Memory location 11
    mem[12] = 32'd0;   // Memory location 12
    mem[13] = 32'd0;   // Memory location 13
    mem[14] = 32'd0;   // Memory location 14
    mem[15] = 32'd0;   // Memory location 15
    mem[16] = 32'd0;   // Memory location 16
    mem[17] = 32'd0;   // Memory location 17
    mem[18] = 32'd0;   // Memory location 18
    mem[19] = 32'd0;   // Memory location 19
    mem[20] = 32'd0;   // Memory location 20
    mem[21] = 32'd0;   // Memory location 21
    mem[22] = 32'd0;   // Memory location 22
    mem[23] = 32'd0;   // Memory location 23
    mem[24] = 32'd0;   // Memory location 24
    mem[25] = 32'd0;   // Memory location 25
    mem[26] = 32'd0;   // Memory location 26
    mem[27] = 32'd0;   // Memory location 27
    mem[28] = 32'd0;   // Memory location 28
    mem[29] = 32'd0;   // Memory location 29
    mem[30] = 32'd0;   // Memory location 30
    mem[31] = 32'd0;   // Memory location 31
    mem[32] = 32'd0;   // Memory location 32
    mem[33] = 32'd0;   // Memory location 33
    mem[34] = 32'd0;   // Memory location 34
    mem[35] = 32'd0;   // Memory location 35
    mem[36] = 32'd0;   // Memory location 36
    mem[37] = 32'd0;   // Memory location 37
    mem[38] = 32'd0;   // Memory location 38
    mem[39] = 32'd0;   // Memory location 39
    mem[40] = 32'd0;   // Memory location 40
    mem[41] = 32'd0;   // Memory location 41
    mem[42] = 32'd0;   // Memory location 42
    mem[43] = 32'd0;   // Memory location 43
    mem[44] = 32'd0;   // Memory location 44
    mem[45] = 32'd0;   // Memory location 45
    mem[46] = 32'd0;   // Memory location 46
    mem[47] = 32'd0;   // Memory location 47
    mem[48] = 32'd0;   // Memory location 48
    mem[49] = 32'd0;   // Memory location 49
    mem[50] = 32'd0;   // Memory location 50
    mem[51] = 32'd0;   // Memory location 51
    mem[52] = 32'd0;   // Memory location 52
    mem[53] = 32'd0;   // Memory location 53
    mem[54] = 32'd0;   // Memory location 54
    mem[55] = 32'd0;   // Memory location 55
    mem[56] = 32'd0;   // Memory location 56
    mem[57] = 32'd0;   // Memory location 57
    mem[58] = 32'd0;   // Memory location 58
    mem[59] = 32'd0;   // Memory location 59
    mem[60] = 32'd0;   // Memory location 60
    mem[61] = 32'd0;   // Memory location 61
    mem[62] = 32'd0;   // Memory location 62
    mem[63] = 32'd0;   // Memory location 63
  end
  always @(*) begin
    if (MemRead) data_out = mem[addr/4];
    else data_out = 32'b0;

  end
  always @(posedge clk) begin
    if (MemWrite) mem[addr/4] = data_in;
  end
endmodule
