`timescale 1ns/1ps

module tb_riscv_top;
  reg clk = 0;
  reg rst = 1;
  reg [31:0] addr;
  wire [31:0] instr;  // Corrigido para "instr" ao invés de "inst"

  // Clock 10ns
  always #5 clk = ~clk;

  riscv_top DUT (
    .clk(clk),
    .rst(rst)
  );

  // Instanciando o módulo instr_mem
  instr_mem IMEM (
    .addr(DUT.pc),  // Passando o valor de 32 bits de addr (PC)
    .instr(instr)    // Conectando a saída instr de 32 bits
  );

  integer i;
  integer cycles = 0;
  localparam MAX_CYCLES = 200;

  initial begin
    $display("=== Iniciando simulacao (Grupo 19) ===");
    #20 rst = 0;  // Libera o reset após 20ns

    // Roda por alguns ciclos
    while (cycles < MAX_CYCLES) begin
      @(posedge clk);
      cycles = cycles + 1;
    end

    $display("\n=== Fim da simulacao. Dump de registradores (x0..x31) ===");
    for (i = 0; i < 32; i = i + 1) begin
      $display("x%0d = %032b", i, DUT.RF.regs[i]); // Exibe os registradores em binário
    end

    $display("\n=== Primeiras 32 posicoes da Data Memory (bytes 0..31) ===");
    for (i = 0; i < 32; i = i + 1) begin
      $display("MEM[%0d] = %08b", i, DUT.DMEM.dmem[i]); // Exibe os valores de MEM em binário
    end

    $display("\n(Verifique se MEM[0] == 0x07)");
    $finish;
  end
endmodule
