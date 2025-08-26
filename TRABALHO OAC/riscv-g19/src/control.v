module control(
  input  wire [6:0] opcode,
  input  wire [2:0] funct3,
  input  wire [6:0] funct7,
  output reg        reg_write,
  output reg        alu_src,
  output reg        mem_read,
  output reg        mem_write,
  output reg        mem_to_reg,
  output reg        branch,
  output reg        lb_op,
  output reg        sb_op,
  output reg        bne_op,
  output reg [3:0]  alu_ctrl
);
  // ALU control encodes (didático):
  localparam ALU_ADD = 4'b0000;
  localparam ALU_AND = 4'b0010;
  localparam ALU_OR  = 4'b0011;
  localparam ALU_SLL = 4'b0100;

  always @* begin
    // defaults
    reg_write  = 1'b0;
    alu_src    = 1'b0;
    mem_read   = 1'b0;
    mem_write  = 1'b0;
    mem_to_reg = 1'b0;
    branch     = 1'b0;
    lb_op      = 1'b0;
    sb_op      = 1'b0;
    bne_op     = 1'b0;
    alu_ctrl   = ALU_ADD;

    case (opcode)
      7'b0110011: begin // R-type: add, and, sll
        reg_write = 1'b1;
        alu_src   = 1'b0;
        case (funct3)
          3'b000: alu_ctrl = ALU_ADD; // add (funct7 0000000)
          3'b111: alu_ctrl = ALU_AND; // and
          3'b001: alu_ctrl = ALU_SLL; // sll
          default: alu_ctrl = ALU_ADD;
        endcase
      end

      7'b0010011: begin // I-type: ori
        reg_write  = 1'b1;
        alu_src    = 1'b1;
        alu_ctrl   = ALU_OR;   // ori
      end

      7'b0000011: begin // LOAD: lb
        reg_write  = 1'b1;
        alu_src    = 1'b1;     // base + imm
        mem_read   = 1'b1;
        mem_to_reg = 1'b1;
        lb_op      = (funct3 == 3'b000); // lb
        alu_ctrl   = ALU_ADD;
      end

      7'b0100011: begin // STORE: sb
        alu_src    = 1'b1;     // base + imm
        mem_write  = 1'b1;
        sb_op      = (funct3 == 3'b000); // sb
        alu_ctrl   = ALU_ADD;
      end

      7'b1100011: begin // BRANCH: bne
        branch     = 1'b1;
        bne_op     = (funct3 == 3'b001); // bne
        // alu_ctrl irrelevante, comparação feita fora
      end
    endcase
  end
endmodule
