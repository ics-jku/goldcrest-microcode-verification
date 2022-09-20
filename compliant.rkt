#lang rosette

(require "model.rkt")

(define microcode
  (list
    ;; # ============================================================
    ;; #                         ARITHMETIC
    ;; Instruction LB
    ;; LB:
    ;; Instruction LH
    ;; LH:
    ;; Instruction LW
    ;; LW:
    ;; Instruction LBU
    ;; LBU:
    ;; Instruction LHU
    ;; LHU:
    ;; Instruction SB
    ;; SB:
    ;; Instruction SH
    ;; SH:
    ;; Instruction SW
    ;; SW:
    ;; Instruction ADDI
    ;; ADDI:
    ;; Instruction ADD
    ;; ADD:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq  IMM TMP0 (bv    1 8))
    (subleq TMP0 SRC2 (bv    1 8))
    ;; addi-exit:
    (subleq NEXT   PC (bv  255 8))
    ;; Instruction SUB
    ;; SUB:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq SRC2  IMM (bv    1 8))
    (subleq SRC2 SRC2 (bv    1 8))
    (subleq  IMM TMP0 (bv    1 8))
    (subleq TMP0 SRC2 (bv    1 8))
    (subleq NEXT   PC (bv  255 8))
    ;; Instruction AUIPC
    ;; AUIPC:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq SRC2 SRC2 (bv    1 8))
    (subleq   PC TMP0 (bv    1 8))
    (subleq TMP0 SRC2 (bv    1 8))
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq  IMM TMP0 (bv    1 8))
    (subleq TMP0 SRC2 (bv    1 8))
    (subleq NEXT   PC (bv  255 8))
    ;; Instruction LUI
    ;; LUI:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq  IMM TMP0 (bv    1 8))
    (subleq TMP0 SRC2 (bv    1 8))
    (subleq NEXT   PC (bv  255 8))
    ;; #                         JUMPS
    ;; Instruction JAL
    ;; JAL:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq TMP1 TMP1 (bv    1 8))
    (subleq SRC2 SRC2 (bv    1 8))
    (subleq  IMM TMP0 (bv    1 8))
    (subleq   PC TMP1 (bv    1 8))
    (subleq TMP1 SRC2 (bv    1 8))
    (subleq NEXT SRC2 (bv    1 8))
    (subleq TMP0   PC (bv  255 8))
    ;; Instruction JALR
    ;; JALR:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq TMP1 TMP1 (bv    1 8))
    (subleq TMP2 TMP2 (bv    1 8))
    (subleq TMP3 TMP3 (bv    1 8))
    (subleq   PC TMP0 (bv    1 8))
    (subleq TMP0 TMP1 (bv    1 8))
    (subleq NEXT TMP1 (bv    1 8))
    (subleq SRC2 TMP2 (bv    1 8))
    (subleq TMP2  IMM (bv    1 8))
    (subleq TMP2 TMP2 (bv    1 8))
    (subleq  IMM TMP2 (bv    1 8))
    (subleq   PC   PC (bv    1 8))
    (subleq TMP2   PC (bv    1 8))
    (subleq SRC2 SRC2 (bv    1 8))
    (subleq TMP1 TMP3 (bv    1 8))
    (subleq TMP3 SRC2 (bv  255 8))
    ;; #                         BRANCHES
    ;; Instruction BEQ
    ;; BEQ:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq TMP1 TMP1 (bv    1 8))
    (subleq SRC2 TMP0 (bv    1 8))
    (subleq TMP0 TMP1 (bv    1 8))
    ;; beq-check-one:
    (subleq SRC1 SRC2 (bv    2 8))
    (subleq TMP0 TMP0 (bv    2 8))
    ;; beq-check-two:
    (subleq TMP1 SRC1 (bv    2 8))
    ;; beq-no-jump-two:
    (subleq NEXT   PC (bv  255 8))
    ;; beq-jump:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq  IMM TMP0 (bv    1 8))
    (subleq TMP0   PC (bv  255 8))
    ;; Instruction BNE
    ;; BNE:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq TMP1 TMP1 (bv    1 8))
    (subleq SRC2 TMP0 (bv    1 8))
    (subleq TMP0 TMP1 (bv    1 8))
    (subleq SRC1 SRC2 (bv    2 8))
    (subleq TMP0 TMP0 (bv    2 8))
    ;; bne-check-two:
    (subleq TMP1 SRC1 (bv    4 8))
    ;; bne-jump:
    (subleq TMP2 TMP2 (bv    1 8))
    (subleq  IMM TMP2 (bv    1 8))
    (subleq TMP2   PC (bv  255 8))
    ;; bne-no-jump:
    (subleq NEXT   PC (bv  255 8))
    ;; Instruction BLT
    ;; BLT:
    (subleq SRC1 SRC2 (bv    5 8))
    ;; blt-jump:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq TMP1 TMP1 (bv    1 8))
    (subleq  IMM TMP0 (bv    1 8))
    (subleq TMP0   PC (bv  255 8))
    ;; blt-no-jump:
    (subleq NEXT   PC (bv  255 8))
    ;; Instruction BGE
    ;; BGE:
    (subleq SRC1 SRC2 (bv    2 8))
    ;; bge-no-jump:
    (subleq NEXT   PC (bv  255 8))
    ;; bge-jump:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq  IMM TMP0 (bv    1 8))
    (subleq TMP0   PC (bv  255 8))
    ;; Instruction BLTU
    ;; BLTU:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq TMP3 TMP3 (bv    1 8))
    (subleq TMP4 TMP4 (bv    1 8))
    (subleq TMP5 TMP5 (bv    1 8))
    (subleq WORD TMP5 (bv    1 8))
    (subleq TMP0 TMP0 (bv    8 8))
    ;; bltu-loop:
    (subleq TMP4 TMP4 (bv    1 8))
    (subleq SRC1 TMP4 (bv    1 8))
    (subleq TMP4 SRC1 (bv    1 8))
    (subleq TMP4 TMP4 (bv    1 8))
    (subleq SRC2 TMP4 (bv    1 8))
    (subleq TMP4 SRC2 (bv    1 8))
    (subleq TMP4 TMP4 (bv    1 8))
    ;; bltu-check:
    (subleq TMP3 TMP3 (bv    1 8))
    (subleq SRC2 TMP3 (bv    3 8))
    (subleq SRC1 TMP3 (bv   10 8))
    (subleq TMP3 TMP3 (bv    4 8))
    ;; bltu-srctwo-pos:
    (subleq TMP3 TMP3 (bv    1 8))
    (subleq SRC1 TMP3 (bv    2 8))
    (subleq TMP0 TMP0 (bv    5 8))
    ;; bltu-next-bit:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq TMP5 TMP0 (bv    3 8))
    (subleq  INC TMP5 (bv    1 8))
    (subleq TMP0 TMP0 (bv  -17 8))
    ;; bltu-next-instruction:
    (subleq NEXT   PC (bv  255 8))
    ;; bltu-jump:
    (subleq  IMM TMP0 (bv    1 8))
    (subleq TMP0   PC (bv  255 8))
    ;; Instruction BGEU
    ;; BGEU:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq TMP3 TMP3 (bv    1 8))
    (subleq TMP4 TMP4 (bv    1 8))
    (subleq TMP5 TMP5 (bv    1 8))
    (subleq WORD TMP5 (bv    1 8))
    (subleq TMP0 TMP0 (bv    8 8))
    ;; bgeu-loop:
    (subleq TMP4 TMP4 (bv    1 8))
    (subleq SRC1 TMP4 (bv    1 8))
    (subleq TMP4 SRC1 (bv    1 8))
    (subleq TMP4 TMP4 (bv    1 8))
    (subleq SRC2 TMP4 (bv    1 8))
    (subleq TMP4 SRC2 (bv    1 8))
    (subleq TMP4 TMP4 (bv    1 8))
    ;; bgeu-check:
    (subleq TMP3 TMP3 (bv    1 8))
    (subleq SRC2 TMP3 (bv    4 8))
    (subleq TMP3 TMP3 (bv    1 8))
    (subleq SRC1 TMP3 (bv   10 8))
    (subleq TMP3 TMP3 (bv    4 8))
    ;; bgeu-srctwo-pos:
    (subleq TMP3 TMP3 (bv    1 8))
    (subleq SRC1 TMP3 (bv    2 8))
    (subleq TMP0 TMP0 (bv    5 8))
    ;; bgeu-next-bit:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq TMP5 TMP0 (bv    4 8))
    (subleq  INC TMP5 (bv    1 8))
    (subleq TMP0 TMP0 (bv  -18 8))
    ;; bgeu-next-instruction:
    (subleq NEXT   PC (bv  255 8))
    ;; bgeu-jump:
    (subleq  IMM TMP0 (bv    1 8))
    (subleq TMP0   PC (bv  255 8))
    ;; #                         BIT LOGIC
    ;; Instruction XORI
    ;; XORI:
    ;; Instruction XOR
    ;; XOR:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq TMP5 TMP5 (bv    1 8))
    (subleq SRC1 SRC1 (bv    1 8))
    (subleq SRC2 TMP0 (bv    1 8))
    (subleq TMP0 SRC1 (bv    1 8))
    (subleq RSLT RSLT (bv    1 8))
    (subleq WORD TMP5 (bv    1 8))
    ;; xor-loop:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq RSLT TMP0 (bv    1 8))
    (subleq TMP0 RSLT (bv    1 8))
    ;; xor-get-msb-src-one:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq SRC1 TMP0 (bv    4 8))
    ;; xor-must-be-zero:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq  IMM TMP0 (bv    4 8))
    (subleq TMP0 TMP0 (bv    4 8))
    ;; xor-must-be-one:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq  IMM TMP0 (bv    2 8))
    ;; xor-set-bit:
    (subleq  INC RSLT (bv    1 8))
    ;; xor-shift:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq SRC1 TMP0 (bv    1 8))
    (subleq TMP0 SRC1 (bv    1 8))
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq  IMM TMP0 (bv    1 8))
    (subleq TMP0  IMM (bv    1 8))
    (subleq  INC TMP5 (bv  -17 8))
    ;; xor-clean:
    (subleq NEXT   PC (bv  255 8))
    ;; Instruction ORI
    ;; ORI:
    ;; Instruction OR
    ;; OR:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq TMP5 TMP5 (bv    1 8))
    (subleq SRC1 SRC1 (bv    1 8))
    (subleq SRC2 TMP0 (bv    1 8))
    (subleq TMP0 SRC1 (bv    1 8))
    (subleq RSLT RSLT (bv    1 8))
    (subleq WORD TMP5 (bv    1 8))
    ;; or-loop:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq RSLT TMP0 (bv    1 8))
    (subleq TMP0 RSLT (bv    1 8))
    ;; or-get-msb-src-one:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq SRC1 TMP0 (bv    2 8))
    (subleq TMP0 TMP0 (bv    3 8))
    ;; or-get-msb-src-two:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq  IMM TMP0 (bv    2 8))
    ;; or-set-bit:
    (subleq  INC RSLT (bv    1 8))
    ;; or-shift:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq SRC1 TMP0 (bv    1 8))
    (subleq TMP0 SRC1 (bv    1 8))
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq  IMM TMP0 (bv    1 8))
    (subleq TMP0  IMM (bv    1 8))
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq  INC TMP5 (bv  -16 8))
    ;; or-clean:
    (subleq NEXT   PC (bv  255 8))
    ;; Instruction ANDI
    ;; ANDI:
    ;; Instruction AND
    ;; AND:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq TMP3 TMP3 (bv    1 8))
    (subleq TMP5 TMP5 (bv    1 8))
    (subleq SRC1 SRC1 (bv    1 8))
    (subleq SRC2 TMP0 (bv    1 8))
    (subleq TMP0 SRC1 (bv    1 8))
    (subleq RSLT RSLT (bv    1 8))
    (subleq WORD TMP5 (bv    1 8))
    ;; and-loop:
    (subleq TMP3 TMP3 (bv    1 8))
    (subleq RSLT TMP3 (bv    1 8))
    (subleq TMP3 RSLT (bv    1 8))
    ;; and-get-msb-src-one:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq SRC1 TMP0 (bv    4 8))
    ;; and-get-msb-src-two:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq  IMM TMP0 (bv    2 8))
    ;; and-set-bit:
    (subleq  INC RSLT (bv    1 8))
    ;; and-shift:
    (subleq TMP3 TMP3 (bv    1 8))
    (subleq SRC1 TMP3 (bv    1 8))
    (subleq TMP3 SRC1 (bv    1 8))
    (subleq TMP3 TMP3 (bv    1 8))
    (subleq  IMM TMP3 (bv    1 8))
    (subleq TMP3  IMM (bv    1 8))
    (subleq  INC TMP5 (bv  -14 8))
    ;; and-clean:
    (subleq NEXT   PC (bv  255 8))
    ;; #                         SHIFTING
    ;; Instruction SLLI
    ;; SLLI:
    ;; Instruction SLL
    ;; SLL:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq TMP1 TMP1 (bv    1 8))
    (subleq SRC1 TMP0 (bv    2 8))
    ;; sll-loop:
    (subleq SRC2 TMP1 (bv    1 8))
    ;; sll-shift:
    (subleq TMP1 SRC2 (bv    1 8))
    (subleq TMP1 TMP1 (bv    1 8))
    (subleq  INC TMP0 (bv   -3 8))
    ;; sll-clean:
    (subleq NEXT   PC (bv  255 8))
    ;; Instruction SRAI
    ;; SRAI:
    ;; Instruction SRA
    ;; SRA:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq SRC1 TMP0 (bv    4 8))
    ;; sra-is-neg:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq  INC TMP0 (bv    1 8))
    (subleq TMP0 RSLT (bv    1 8))
    ;; sra-is-pos:
    ;; Instruction SRLI
    ;; SRLI:
    ;; Instruction SRL
    ;; SRL:
    ;; srl:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq TMP5 TMP5 (bv    1 8))
    (subleq WORD TMP5 (bv    1 8))
    (subleq  IMM TMP0 (bv    1 8))
    (subleq TMP0 TMP5 (bv    1 8))
    ;; srl-msb-check:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq SRC1 TMP0 (bv    6 8))
    ;; srl-msb-set:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq RSLT TMP0 (bv    1 8))
    (subleq TMP0 RSLT (bv    1 8))
    (subleq  INC RSLT (bv    1 8))
    (subleq TMP0 TMP0 (bv    4 8))
    ;; srl-msb-unset:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq RSLT TMP0 (bv    1 8))
    (subleq TMP0 RSLT (bv    1 8))
    ;; srl-check-loop:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq TMP5 TMP0 (bv    6 8))
    ;; srl-move-op:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq SRC1 TMP0 (bv    1 8))
    (subleq TMP0 SRC1 (bv    1 8))
    (subleq  INC TMP5 (bv    1 8))
    (subleq TMP0 TMP0 (bv  -16 8))
    ;; srl-end:
    (subleq NEXT   PC (bv  255 8))
    ;; #                         SET BIT
    ;; Instruction SLTI
    ;; SLTI:
    ;; Instruction SLT
    ;; SLT:
    ;; slt-check-one:
    (subleq SRC1 SRC2 (bv    4 8))
    ;; slt-set:
    (subleq SRC2 SRC2 (bv    1 8))
    (subleq  INC SRC2 (bv    1 8))
    (subleq NEXT   PC (bv  255 8))
    ;; slt-no-set:
    (subleq SRC2 SRC2 (bv    1 8))
    (subleq NEXT   PC (bv  255 8))
    ;; Instruction SLTIU
    ;; SLTIU:
    ;; Instruction SLTU
    ;; SLTU:
    ;; # jump if src1 < src2 unsigned
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq TMP3 TMP3 (bv    1 8))
    (subleq TMP4 TMP4 (bv    1 8))
    (subleq TMP5 TMP5 (bv    1 8))
    (subleq WORD TMP5 (bv    1 8))
    (subleq TMP0 TMP0 (bv    8 8))
    ;; sltu-loop:
    (subleq TMP4 TMP4 (bv    1 8))
    (subleq SRC1 TMP4 (bv    1 8))
    (subleq TMP4 SRC1 (bv    1 8))
    (subleq TMP4 TMP4 (bv    1 8))
    (subleq SRC2 TMP4 (bv    1 8))
    (subleq TMP4 SRC2 (bv    1 8))
    (subleq TMP4 TMP4 (bv    1 8))
    ;; sltu-check:
    (subleq TMP3 TMP3 (bv    1 8))
    (subleq SRC2 TMP3 (bv    4 8))
    (subleq TMP3 TMP3 (bv    1 8))
    (subleq SRC1 TMP3 (bv   10 8))
    (subleq TMP3 TMP3 (bv    4 8))
    ;; sltu-srctwo-pos:
    (subleq TMP3 TMP3 (bv    1 8))
    (subleq SRC1 TMP3 (bv    2 8))
    (subleq TMP0 TMP0 (bv    5 8))
    ;; sltu-next-bit:
    (subleq TMP0 TMP0 (bv    1 8))
    (subleq TMP5 TMP0 (bv    3 8))
    (subleq  INC TMP5 (bv    1 8))
    (subleq TMP0 TMP0 (bv  -18 8))
    ;; sltu-next-instruction:
    (subleq RSLT RSLT (bv    3 8))
    ;; sltu-jump:
    (subleq RSLT RSLT (bv    1 8))
    (subleq  INC RSLT (bv    1 8))
    ;; sltu-exit:
    (subleq NEXT   PC (bv  255 8))))

(define LB-PC (bv 0 9))
(define LH-PC (bv 0 9))
(define LW-PC (bv 0 9))
(define LBU-PC (bv 0 9))
(define LHU-PC (bv 0 9))
(define SB-PC (bv 0 9))
(define SH-PC (bv 0 9))
(define SW-PC (bv 0 9))
(define ADDI-PC (bv 0 9))
(define ADD-PC (bv 0 9))
(define SUB-PC (bv 4 9))
(define AUIPC-PC (bv 10 9))
(define LUI-PC (bv 18 9))
(define JAL-PC (bv 22 9))
(define JALR-PC (bv 30 9))
(define BEQ-PC (bv 46 9))
(define BNE-PC (bv 57 9))
(define BLT-PC (bv 68 9))
(define BGE-PC (bv 74 9))
(define BLTU-PC (bv 79 9))
(define BGEU-PC (bv 106 9))
(define XORI-PC (bv 134 9))
(define XOR-PC (bv 134 9))
(define ORI-PC (bv 160 9))
(define OR-PC (bv 160 9))
(define ANDI-PC (bv 185 9))
(define AND-PC (bv 185 9))
(define SLLI-PC (bv 209 9))
(define SLL-PC (bv 209 9))
(define SRAI-PC (bv 217 9))
(define SRA-PC (bv 217 9))
(define SRLI-PC (bv 222 9))
(define SRL-PC (bv 222 9))
(define SLTI-PC (bv 245 9))
(define SLT-PC (bv 245 9))
(define SLTIU-PC (bv 251 9))
(define SLTU-PC (bv 251 9))

(provide microcode LB-PC LH-PC LW-PC LBU-PC LHU-PC SB-PC SH-PC SW-PC ADDI-PC ADD-PC SUB-PC AUIPC-PC LUI-PC JAL-PC JALR-PC BEQ-PC BNE-PC BLT-PC BGE-PC BLTU-PC BGEU-PC XORI-PC XOR-PC ORI-PC OR-PC ANDI-PC AND-PC SLLI-PC SLL-PC SRAI-PC SRA-PC SRLI-PC SRL-PC SLTI-PC SLT-PC SLTIU-PC SLTU-PC)
