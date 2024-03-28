module LoadController (
    input [31:0] mem_data,
    input [5:0] addr,
    input [2:0] funct3,
    output reg [31:0] data_out
);
  localparam LB = 3'h0;
  localparam LH = 3'h1;
  localparam LW = 3'h2;
  localparam LBU = 3'h4;
  localparam LHU = 3'h5;

  always @(*) begin
    case (funct3)
      LB:
      case (addr % 4)
        0: data_out = {{24{mem_data[31]}}, mem_data[7:0]};
        1: data_out = {{24{mem_data[31]}}, mem_data[15:8]};
        2: data_out = {{24{mem_data[31]}}, mem_data[23:16]};
        3: data_out = {{24{mem_data[31]}}, mem_data[31:24]};
      endcase
      LH:
      case (addr % 4)
        0: data_out = {{16{mem_data[31]}}, mem_data[15:0]};
        1: begin
          $display("WARNING: Address %h is not aligned on half word boundary", addr);
          data_out = {{16{mem_data[31]}}, mem_data[15:0]};
        end
        2: data_out = {{16{mem_data[31]}}, mem_data[31:16]};
        3: begin
          $display("WARNING: Address %h is not aligned on half word boundary", addr);
          data_out = {{16{mem_data[31]}}, mem_data[31:16]};
        end
      endcase
      LW: data_out = mem_data;
      LBU:
      case (addr % 4)
        0: data_out = {24'b0, mem_data[7:0]};
        1: data_out = {24'b0, mem_data[15:8]};
        2: data_out = {24'b0, mem_data[23:16]};
        3: data_out = {24'b0, mem_data[31:24]};
      endcase
      LHU:
      case (addr % 4)
        0: data_out = {16'b0, mem_data[15:0]};
        1: begin
          data_out = {16'b0, mem_data[15:0]};
          $display("WARNING: Address %h is not aligned on half word boundary", addr);
        end
        2: data_out = {16'b0, mem_data[31:16]};
        3: begin
          data_out = {16'b0, mem_data[31:16]};
          $display("WARNING: Address %h is not aligned on half word boundary", addr);
        end
      endcase
      default: begin
        $display("Error in LoadController: Unkown funct3 value %d", funct3);
        data_out = 32'h0;
      end
    endcase
  end
endmodule
