module InstructionMem (
    input  [ 7:0] addr,
    output [31:0] inst
);
  reg [31:0] mem[31:0];
  assign inst = mem[addr/4];

  initial begin
    // --------------------------------------------------------------------
    // This program calculates the first 10 Fibonacci sequence numbers and
    // writes them to memory starting at address 16.
    // This requires certain values to be present in the data memory. Refer
    // to the file DataMem.v for more details.
    // --------------------------------------------------------------------
    //                # Initialize constants
    // 0x00c02c03:    lw s8, 12(x0)
    // 0x00402483:    lw s1, 4(x0)
    // 0x00802a03:    lw s4, 8(x0)
    //
    // 0x018002b3:    add t0, x0, s8  # Base address to write to
    // 0x00002303:    lw  t1, 0(x0)   # Number of Fibonacci values to calculate
    // 0x00402e83:    lw  t4, 4(x0)   # Fibonacci value f(n-1), t3 = f(n-2) = 0 initially
    //
    //            fib_loop:
    //                # Calculate the next Fibonacci value: f(n) = f(n-1) + f(n-2)
    // 0x01de0f33:    add t5, t3, t4  # t5 = f(n-1) + f(n-2)
    //
    //                # Store the Fibonacci value to memory
    // 0x01e2a023:    sw  t5, 0(t0)   # Store the Fibonacci value at the current memory address
    //
    //                # Update Fibonacci values for next iteration
    // 0x000e8e33:    add t3, t4, x0  # Update f(n-2) to f(n-1)
    // 0x000f0eb3:    add t4, t5, x0  # Update f(n-1) to the newly calculated value
    //
    //                # Update memory address
    // 0x014282b3:    add t0, t0, s4  # Move to the next memory address
    //
    //                # Update loop counter
    // 0x009383b3:    add t2, t2, s1  # Increment loop counter
    //
    //                # Check if we have calculated all Fibonacci values
    // 0x00638463:    beq t2, t1, exit
    // 0xfe0002e3:    beq x0, x0, fib_loop
    //            exit:
    mem[0]  = 32'h10203317;
    mem[1]  = 32'habcde397;
    mem[2]  = 32'h10101e17;
    mem[3]  = 32'h00100073;
    mem[4]  = 32'h0ff0000f;
    mem[5]  = 32'h00000073;
    mem[6]  = 32'h00000000;
    mem[7]  = 32'h00000000;
    mem[8]  = 32'h00000000;
    mem[9]  = 32'h00000000;
    mem[10] = 32'h00000000;
    mem[11] = 32'h00000000;
    mem[12] = 32'h00000000;
    mem[13] = 32'h00000000;
    mem[14] = 32'h00000000;
    mem[15] = 32'h00000000;
    mem[16] = 32'h00000000;
    mem[17] = 32'h00000000;
    mem[18] = 32'h00000000;
    mem[19] = 32'h00000000;
    mem[20] = 32'h00000000;
    mem[21] = 32'h00000000;
    mem[22] = 32'h00000000;
    mem[23] = 32'h00000000;
    mem[24] = 32'h00000000;
    mem[25] = 32'h00000000;
    mem[26] = 32'h00000000;
    mem[27] = 32'h00000000;
    mem[28] = 32'h00000000;
    mem[29] = 32'h00000000;
    mem[30] = 32'h00000000;
    mem[31] = 32'h00000000;
    // $readmemh("instructions.txt", mem);
  end
endmodule
