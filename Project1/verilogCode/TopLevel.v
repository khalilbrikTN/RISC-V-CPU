`include "../../sources_1/new/RCA.v"
`include "../../sources_1/new/InstructionMem.v"
`include "../../sources_1/new/NReg.v"
`include "../../sources_1/new/SSD.v"
`include "../../sources_1/new/ControlUnit.v"
`include "../../sources_1/new/RegFile.v"
`include "../../sources_1/new/ALUCtrl.v"
`include "../../sources_1/new/Mux.v"
`include "../../sources_1/new/ALU.v"
`include "../../sources_1/new/DataMem.v"
`include "../../sources_1/new/ShiftLeft1.v"
`include "../../sources_1/new/pc.v"
`include "../../sources_1/new/Immgen.v"
`include "../../sources_1/new/branch_ctrl.v"

`timescale 1ns / 1ps

module TopLevel (
    input clk,
    input pb_clk,
    input rst,
    input [1:0] led_sel,
    input [3:0] ssd_sel,
    output reg [15:0] leds,
    output [3:0] anode,
    output [6:0] led_out,
    output [3:0] disable_anodes,
    output program_finished
);
  // local parameters for case statements
  localparam SSD_SEL_PC = 4'b0000;
  localparam SSD_SEL_PC_P4 = 4'b0001;
  localparam SSD_SEL_BRANCH_TARGET_ADDR = 4'b0010;
  localparam SSD_SEL_PC_INPUT = 4'b0011;
  localparam SSD_SEL_DATA_RF_RS1 = 4'b0100;
  localparam SSD_SEL_DATA_RF_RS2 = 4'b0101;
  localparam SSD_SEL_DATA_RF_IN = 4'b0110;
  localparam SSD_SEL_IMM_GEN_OUT = 4'b0111;
  localparam SSD_SEL_SHIFTL1_OUT = 4'b1000;
  localparam SSD_SEL_ALU_SRC2_MUX = 4'b1001;
  localparam SSD_SEL_ALU_OUT = 4'b1010;
  localparam SSD_SEL_MEM_OUT = 4'b1011;

  localparam LED_SEL_INST_LSH = 2'b00;  // least significant half
  localparam LED_SEL_INST_MSH = 2'b01;  // most significant half
  localparam LED_SEL_CONTROL_SIG = 2'b10;

  // Wires for datapath
  wire [ 7:0] pc_input;
  wire [ 7:0] pc_input_with_reset_output;
  wire [ 7:0] pc_output;
  reg  [12:0] ssd_num;
  wire [ 7:0] pc_p4_adder_output;
  wire [31:0] instruction;
  wire [31:0] immediate_expanded;
  wire [31:0] shift_left_output;
  wire [ 7:0] shift_left_pc_adder_output;
  wire [31:0] alu_first_input;
  assign alu_first_input = AUIPCSel ? pc_output : read_data1;
  wire [31:0] alu_second_input;
  wire unsigned_signal;
  wire [31:0] alu_result;
  wire [31:0] write_data;
  assign write_data = PassImm ? immediate_expanded : load_cu_or_alu_out;
  wire [31:0] load_cu_or_alu_out;
  wire [31:0] read_data1;
  wire [31:0] read_data2;
  wire [31:0] data_mem_out;
  wire [31:0] load_controller_out;
  wire Branch;
  wire MemRead;
  wire MemtoReg;
  wire MemWrite;
  wire ALUSrc;
  wire RegWrite;
  wire PassImm;
  wire AUIPCSel;
  wire EnvironmentCall;
  assign program_finished = EnvironmentCall && immediate_expanded == 0;
  wire branch_sel;
  wire [1:0] jump;
  wire [1:0] ALUOp;
  wire zflag;
  wire negative_flag;
  wire branch_and_output;
  assign branch_and_output = Branch && zflag;
  wire [ 3:0] alu_ctrl;
  wire [15:0] control_signals;
  assign control_signals = {
    2'b00,
    Branch,
    MemRead,
    MemtoReg,
    ALUOp,
    MemWrite,
    ALUSrc,
    RegWrite,
    alu_ctrl,
    zflag,
    branch_and_output
  };

  branch_ctrl branch_control (
      .branch_op(instruction[14:12]),
      .branch(Branch),
      .zf(zflag),
      .negative(negative_flag),
      .branch_sel(branch_sel)
  );

  pc program_counter (
      .alu_result(alu_result),
      .clk(clk),
      .rst(rst),
      .immediate(immediate_expanded),
      .branch_sel(branch_sel),
      .jump(jump),
      .program_finished(program_finished),
      .counter(pc_output)
  );

  SSD ssd (
      .clk(clk),
      .num(ssd_num),
      .Anode(anode),
      .LED_out(led_out),
      .disable_anodes(disable_anodes)
  );

  RCA pc_p4_adder (
      .a  (pc_output),
      .b  (8'd4),
      .sum(pc_p4_adder_output)
  );

  InstructionMem instmem (
      .addr(pc_output),
      .inst(instruction)
  );

  ControlUnit cu (
      .opcode(instruction[6:2]),
      .Branch(Branch),
      .MemRead(MemRead),
      .MemtoReg(MemtoReg),
      .MemWrite(MemWrite),
      .ALUSrc(ALUSrc),
      .RegWrite(RegWrite),
      .ALUOp(ALUOp),
      .PassImm(PassImm),
      .AUIPCSel(AUIPCSel),
      .EnvironmentCall(EnvironmentCall),
      .jump(jump)
  );

  RegFile regfile (
      .clk(pb_clk),
      .rst(rst),
      .regWrite(RegWrite),
      .readAddr1(instruction[19:15]),
      .readAddr2(instruction[24:20]),
      .writeAddr(instruction[11:7]),
      .writeData(write_data),
      .outputReg1(read_data1),
      .outputReg2(read_data2)
  );

  ALUCtrl alu_cu (
      .alu_op(ALUOp),
      .func7bit30(instruction[30]),
      .func3(instruction[14:12]),
      .alu_ctrl(alu_ctrl),
      .unsigned_signal(unsigned_signal)
  );

  ImmGen imm_gen (
      .inst(instruction),
      .gen_out(immediate_expanded)
  );

  Mux #(
      .N(32)
  ) alu_second_input_mux (
      .in0(read_data2),
      .in1(immediate_expanded),
      .sel(ALUSrc),
      .out(alu_second_input)
  );

  ALU alu (
      .rs1(alu_first_input),
      .rs2(alu_second_input),
      .alu_ctrl(alu_ctrl),
      .unsigned_signal(unsigned_signal),
      .res(alu_result),
      .zf(zflag),
      .neg(negative_flag)
  );

  DataMem datamem (
      .clk(pb_clk),
      .MemRead(MemRead),
      .MemWrite(MemWrite),
      .addr(alu_result[5:0]),
      .data_in(read_data2),
      .data_out(data_mem_out)
  );

  LoadController load_controller (
      .mem_data(data_mem_out),
      .addr(alu_result[5:0]),
      .funct3(instruction[14:12]),
      .data_out(load_controller_out)
  );

  Mux #(
      .N(32)
  ) rf_write_data_mux (
      .in0(alu_result),
      .in1(load_controller_out),
      .sel(MemtoReg),
      .out(load_cu_or_alu_out)
  );

  ShiftLeft1 shiftleft1 (
      .a(immediate_expanded),
      .b(shift_left_output)
  );

  RCA shift_left_pc_adder (
      .a  (pc_output),
      .b  (shift_left_output[7:0]),
      .sum(shift_left_pc_adder_output)
  );

  Mux #(
      .N(8)
  ) pc_input_mux (
      .in0(pc_p4_adder_output),
      .in1(shift_left_pc_adder_output),
      .sel(branch_and_output),
      .out(pc_input)
  );

  Mux #(
      .N(8)
  ) pc_input_with_reset_mux (
      .in0(pc_input),
      .in1(8'b0),
      .sel(rst),
      .out(pc_input_with_reset_output)
  );

  always @(*) begin
    case (ssd_sel)
      SSD_SEL_PC: ssd_num = pc_output;
      SSD_SEL_PC_P4: ssd_num = pc_p4_adder_output;
      SSD_SEL_BRANCH_TARGET_ADDR: ssd_num = shift_left_pc_adder_output;
      SSD_SEL_PC_INPUT: ssd_num = pc_input_with_reset_output;
      SSD_SEL_DATA_RF_RS1: ssd_num = read_data1;
      SSD_SEL_DATA_RF_RS2: ssd_num = read_data2;
      SSD_SEL_DATA_RF_IN: ssd_num = write_data;
      SSD_SEL_IMM_GEN_OUT: ssd_num = immediate_expanded;
      SSD_SEL_SHIFTL1_OUT: ssd_num = shift_left_output;
      SSD_SEL_ALU_SRC2_MUX: ssd_num = alu_second_input;
      SSD_SEL_ALU_OUT: ssd_num = alu_result;
      SSD_SEL_MEM_OUT: ssd_num = data_mem_out;
    endcase
  end

  always @(*) begin
    case (led_sel)
      LED_SEL_INST_LSH: leds = instruction[15:0];
      LED_SEL_INST_MSH: leds = instruction[31:16];
      LED_SEL_CONTROL_SIG: leds = control_signals;
      default: leds = 16'hFFFF;
    endcase
  end
endmodule
