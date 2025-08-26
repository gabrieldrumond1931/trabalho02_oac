module alu(
  input  wire [31:0] a,
  input  wire [31:0] b,
  input  wire [3:0]  alu_ctrl,
  output reg  [31:0] y,
  output wire        zero
);
  localparam ALU_ADD = 4'b0000;
  localparam ALU_AND = 4'b0010;
  localparam ALU_OR  = 4'b0011;
  localparam ALU_SLL = 4'b0100;

  always @* begin
    case (alu_ctrl)
      ALU_ADD: y = a + b;
      ALU_AND: y = a & b;
      ALU_OR : y = a | b;
      ALU_SLL: y = a << b[4:0];
      default: y = 32'd0;
    endcase
  end

  assign zero = (y == 32'd0);
endmodule
