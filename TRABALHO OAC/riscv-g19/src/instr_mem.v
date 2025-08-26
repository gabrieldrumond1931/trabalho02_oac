module instr_mem (
    input wire [31:0] addr,   // Endereço de 32 bits
    output reg [31:0] instr   // Instrução de 32 bits (saída)
);

    reg [31:0] imem [0:255];   // Memória de 256 palavras (1 KB)

    integer i;

    // Inicializa a memória e preenche com 0 se necessário
    initial begin
        // Lê o arquivo de memória de instruções (prog.mem) em binário
        $readmemb("sim/prog.mem", imem);

        // Se o arquivo de memória tiver menos de 256 palavras, preenche com NOP
        for (i = $size(imem); i < 256; i = i + 1) begin
            imem[i] = 32'b00000000000000000000000000010001;  // NOP=ADDI x0,x0,0 (binário)
        end
    end

    // Sempre que o endereço mudar, a instrução correspondente é lida
    always @(addr) begin
        instr = imem[addr >> 2];  // Divide o endereço por 4 (acesso à palavra)
    end

    // Exibe os valores da memória em binário quando solicitado
    always @(instr) begin
        $display("Instrucao em binario: %032b", instr); // Exibe a instrução em binário de 32 bits
    end

endmodule
