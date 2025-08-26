module regfile(
  input  wire        clk,
  input  wire        we,
  input  wire [4:0]  rs1,
  input  wire [4:0]  rs2,
  input  wire [4:0]  rd,
  input  wire [31:0] rd_data,
  output wire [31:0] rs1_data,
  output wire [31:0] rs2_data
);
  reg [31:0] regs [0:31];

  // x0 sempre zero
  assign rs1_data = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
  assign rs2_data = (rs2 == 5'd0) ? 32'd0 : regs[rs2];

  always @(posedge clk) begin
    if (we && rd != 5'd0)
      regs[rd] <= rd_data;
  end

  // Inicialização por arquivo externo
  initial begin
    integer i;
    for (i = 0; i < 32; i = i + 1) regs[i] = 32'd0;
    $readmemh("sim/regs_init.mem", regs);
  end
endmodule
