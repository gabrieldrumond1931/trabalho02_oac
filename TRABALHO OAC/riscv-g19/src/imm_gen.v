module imm_gen(
  input  wire [31:0] instr,
  output reg  [31:0] imm
);
  wire [6:0] opcode = instr[6:0];

  reg [12:0] b_imm; // B-type immediate (13 bits, bit0=0)

  always @* begin
    case (opcode)
      7'b0010011, 7'b0000011: begin
        // I-type: [31:20]
        imm = {{20{instr[31]}}, instr[31:20]};
      end
      7'b0100011: begin
        // S-type: [31:25|11:7]
        imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
      end
      7'b1100011: begin
        // B-type: [31|7|30:25|11:8|0] << 1; retornamos já alinhado em bytes
        b_imm = {instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
        imm   = {{19{b_imm[12]}}, b_imm}; // sign-extend para 32 bits
      end
      default: begin
        imm = 32'd0;
      end
    endcase
  end
endmodule
