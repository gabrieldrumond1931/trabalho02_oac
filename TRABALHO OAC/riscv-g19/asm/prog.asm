        # Grupo 19: lb, sb, add, and, ori, sll, bne
        # Convenção: x0=zero, x1..x31 livres.

        lb   x1, 32(x0)       # x1 = MEM[32] (byte)  => deve ler 7
        add  x2, x1, x0       # x2 = x1              => 7
        ori  x4, x0, 1        # x4 = 1               (imediato via ORI)
        sll  x5, x1, x4       # x5 = 7 << 1          => 14
        and  x6, x5, x1       # x6 = 14 & 7          => 6
        add  x8, x6, x0       # x8 = x6              => 6

        # Se x6 != 0, desvia para SAIDA (deve desviar)
        bne  x6, x0, SAIDA

        # FAIL PATH (não deve executar se o desvio funcionou):
        add  x1, x1, x1
        sb   x1, 0(x0)

SAIDA:
        sb   x2, 0(x0)        # grava 7 em MEM[0] (byte)

        # NOP: bne não-tomado (só pra manter execução estável)
        bne  x0, x0, SAIDA
