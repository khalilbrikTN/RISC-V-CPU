`timescale 1ns / 1ps

module RegFile #(
    parameter DATA_WIDTH = 32
) (
    input clk,  // Clock
    input rst,  // Reset
    input regWrite,  // Control signal for write operation from CU
    input [4:0] readAddr1,  // Read address 1
    input [4:0] readAddr2,  // Read address 2
    input [4:0] writeAddr,  // Write address
    input [DATA_WIDTH-1:0] writeData,  // Data to be written
    output [DATA_WIDTH-1:0] outputReg1,  // Output register 1
    output [DATA_WIDTH-1:0] outputReg2  // Output register 2
);

  // Internal register file array
  reg [DATA_WIDTH-1:0] registerFile[31:0];

  // Initialize register file array
  integer i;
  initial begin
    for (i = 0; i < DATA_WIDTH; i = i + 1) begin
      registerFile[i] = 32'b0;
    end
  end

  // Output assignment
  assign outputReg1 = registerFile[readAddr1];
  assign outputReg2 = registerFile[readAddr2];

  // Register file write logic
  always @(negedge clk or posedge rst) begin
    if (rst) begin
      for (i = 0; i < DATA_WIDTH; i = i + 1) begin
        registerFile[i] <= 32'b0;
      end
    end else if (regWrite && writeAddr != 0) begin
      registerFile[writeAddr] <= writeData;
    end
  end
endmodule
