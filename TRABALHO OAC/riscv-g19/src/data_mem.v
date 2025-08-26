module data_mem (
    input wire clk,
    input wire [31:0] addr,  // Endereço de 32 bits
    input wire we,           // Write Enable
    input wire re,           // Read Enable
    input wire [31:0] wdata, // Dados a escrever
    output reg [31:0] rdata, // Dados lidos
    input wire sb_op,        // Sinal de escrita de byte
    input wire lb_op         // Sinal de leitura de byte com sign-extend
);

    reg [31:0] dmem [0:255];  // Memória de 256 palavras (1 KB)

    // Inicializa a memória e preenche com 0 se necessário
    initial begin
        // Lê o arquivo de dados em binário
        $readmemb("sim/data_init.mem", dmem);

        // Se o arquivo de memória tiver menos de 256 bytes, preenche com 0
        for (integer i = $size(dmem); i < 256; i = i + 1) begin
            dmem[i] = 32'b00000000000000000000000000000000;  // Preenche com 0
        end
    end

    // Processamento de leitura e escrita
    always @(posedge clk) begin
        if (we) begin
            if (sb_op) begin
                // Escreve byte (somente o byte menos significativo)
                dmem[addr] <= {24'b0, wdata[7:0]}; // Escreve apenas os 8 bits
            end else begin
                dmem[addr] <= wdata; // Escreve a palavra completa
            end
        end
        if (re) begin
            if (lb_op) begin
                // Lê byte com sign-extend
                rdata <= {{24{dmem[addr][7]}}, dmem[addr][7:0]}; // Extensão de sinal
            end else begin
                rdata <= dmem[addr]; // Lê a palavra completa
            end
        end
    end

endmodule
