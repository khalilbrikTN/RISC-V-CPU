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
    $readmemh("../../sources_1/new/instructions.txt", mem);

  end
endmodule
