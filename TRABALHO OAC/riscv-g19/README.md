# RISC-V Grupo 19 — TP (lb, sb, add, and, ori, sll, bne)

## Estrutura
```
riscv-g19/
├─ src/               # Verilog
├─ sim/               # Testbench e arquivos de entrada
└─ asm/               # Código ASM
```

## Passo a passo (Icarus Verilog)
1) Instale o Icarus Verilog (Linux):
```bash
sudo apt-get update && sudo apt-get install -y iverilog
```
No Windows, instale via choco:
```powershell
choco install icarus-verilog
```

2) Dentro da raiz do projeto:
```bash
iverilog -g2012 -o sim.out src/*.v sim/tb_riscv_top.v
vvp sim.out
```

3) Saída esperada no final:
- `MEM[0] = 0x07` nas primeiras 32 posições da memória.
- Registradores coerentes, por exemplo: x1=7, x2=7, x6=6, x8=6.

## Quatro arquivos exigidos no enunciado
- `asm/prog.asm` (ASM do teste)
- `sim/prog.mem` (ASM → binário em hex)
- `sim/regs_init.mem` (estado inicial dos registradores)
- `sim/data_init.mem` (estado inicial da memória de dados; byte 32 = 0x07)

## Observações
- A instrução `bne` já está com o imediato/alinhamento correto para saltar o bloco de FAIL e gravar `7` em `MEM[0]`.
- A memória de dados é **endereçável por byte** e `lb/sb` funcionam com sinalização (`lb` faz sign-extend do byte lido).
