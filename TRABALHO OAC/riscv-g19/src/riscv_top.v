`timescale 1ns/1ps

module riscv_top(
  input  wire  clk,
  input  wire  rst
);

  // =========================
  // PC (Program Counter)
  // =========================
  reg [31:0] pc;
  wire [31:0] pc_next;
  wire [31:0] pc_plus4 = pc + 32'd4;

  always @(posedge clk or posedge rst) begin
    if (rst) pc <= 32'd0;
    else     pc <= pc_next;
  end

  // =========================
  // Instrução
  // =========================
  wire [31:0] instr;
  instr_mem IMEM (
    .addr (pc),  // Passando o valor de 32 bits de addr (PC)
    .instr(instr)
  );

  // Campos da instrução
  wire [6:0]  opcode = instr[6:0];
  wire [4:0]  rd     = instr[11:7];
  wire [2:0]  funct3 = instr[14:12];
  wire [4:0]  rs1    = instr[19:15];
  wire [4:0]  rs2    = instr[24:20];
  wire [6:0]  funct7 = instr[31:25];

  // =========================
  // Controle e Imediatos
  // =========================
  wire       reg_write, alu_src, mem_read, mem_write, mem_to_reg, branch;
  wire [3:0] alu_ctrl;
  wire       lb_op, sb_op;   // sinaliza acesso a byte
  wire       bne_op;         // branch do tipo BNE

  control CTRL (
    .opcode   (opcode),
    .funct3   (funct3),
    .funct7   (funct7),
    .reg_write(reg_write),
    .alu_src  (alu_src),
    .mem_read (mem_read),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),
    .branch   (branch),
    .lb_op    (lb_op),
    .sb_op    (sb_op),
    .bne_op   (bne_op),
    .alu_ctrl (alu_ctrl)
  );

  wire [31:0] imm;
  imm_gen IMM (
    .instr (instr),
    .imm   (imm)
  );

  // =========================
  // Banco de Registradores
  // =========================
  wire [31:0] rs1_data, rs2_data, rd_data;
  regfile RF (
    .clk      (clk),
    .we       (reg_write),
    .rs1      (rs1),
    .rs2      (rs2),
    .rd       (rd),
    .rd_data  (rd_data),
    .rs1_data (rs1_data),
    .rs2_data (rs2_data)
  );

  // =========================
  // ALU
  // =========================
  wire [31:0] alu_b = (alu_src) ? imm : rs2_data;
  wire [31:0] alu_y;
  wire        alu_zero;

  alu ALU (
    .a       (rs1_data),
    .b       (alu_b),
    .alu_ctrl(alu_ctrl),
    .y       (alu_y),
    .zero    (alu_zero)
  );

  // =========================
  // Data Memory (byte endereçável)
  // =========================
  wire [31:0] dmem_rdata;
  data_mem DMEM (
    .clk    (clk),
    .addr   (alu_y),    // endereço de dados = rs1 + imm (lb/sb)
    .we     (mem_write),
    .re     (mem_read),
    .sb_op  (sb_op),    // escrita de byte
    .lb_op  (lb_op),    // leitura de byte com sign-extend
    .wdata  (rs2_data), // valor a armazenar (byte menos significativo usado em SB)
    .rdata  (dmem_rdata)
  );

  // =========================
  // Write-back mux
  // =========================
  wire [31:0] wb_data = (mem_to_reg) ? dmem_rdata : alu_y;
  assign rd_data = wb_data;

  // =========================
  // Branch BNE
  // =========================
  wire br_taken = branch && bne_op && (rs1_data != rs2_data);
  wire [31:0] br_target = pc + imm; // imm já vem alinhado (bytes) e sign-extend

  assign pc_next = (br_taken) ? br_target : pc_plus4;

endmodule
