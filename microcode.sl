! Compliant
# ============================================================
#                         ARITHMETIC
# ============================================================
@ADD
	TMP0
	NEXT RVPC
	SRC1 TMP0
	TMP0 SRC2 END
	
@LB
@LH
@LW
@LBU
@LHU
@SB
@SH
@SW
@ADDI
@LUI # 0 // 0
	TMP0
	IMMI  TMP0		# negate IMMI   | TMP0 - IMMI = 0 - mem[IMMI]
	TMP0 SRC2     	  	# SRC2 - -(TMP0)
addi-exit:	
	NEXT RVPC END		# increment RISC-V pc

@SUB # 4 // 100
	IMMI SRC2
	NEXT RVPC END		# increment RISC-V pc

@AUIPC # 6 // 1010
	TMP0
	SRC2
	RVPC TMP0			# copy RVPC to SRC2
	TMP0 SRC2
	TMP0			# RVPC + IMMI
	IMMI TMP0
	TMP0 SRC2
	NEXT RVPC END

# ============================================================
#                         JUMPS
# ============================================================
@JAL # 14 // 10110
	TMP0
	TMP1
	SRC2			# reset SRC2
	IMMI  TMP0	      	# negate IMMI
	RVPC   TMP1     	       	# -pc => TMP1
	TMP1 SRC2     	       	# pc => SRC2
	NEXT SRC2              	# add link address +4
	TMP0 RVPC END    	       	# RVPC - -TMP0

@JALR # 22 // 11110
	TMP0     		# reset TMP0
	TMP1     		# reset TMP1
	TMP2     		# reset TMP2
	TMP3 			# reset TMP3
	SRC2 TMP1     		# -SRC2 => TMP1   calculate jump target
	TMP1 IMMI      		# IMMI --(SRC2)  
	TMP1     		# reset TMP1    set new pc after jump
jalr-prep:
	WORD TMP0
	INCR TMP0
	IMMI TMP3		# save IMMI
jalr-loop:
	TMP2
	IMMI TMP2
	TMP2 IMMI
	INCR TMP0 jalr-loop
	TMP0
	IMMI TMP0 jalr-fin
	INCR TMP3
jalr-fin:
	IMMI
	TMP3 IMMI
	IMMI TMP1     		# -(SRC2 + IMMI) => TMP1
	NEXT RVPC     		# RVPC + 4
	TMP0
	RVPC TMP0			# -(RVPC + 4) store link pc	
	RVPC         		# reset RVPC
	TMP1 RVPC       		# (SRC2 + IMMI) => RVPC
	SRC2     		# reset SRC2
	TMP0 SRC2 END  		# (RVPC + 4) => SRC2

# ============================================================
#                         BRANCHES
# ============================================================
@BEQ # 46 // 101110
beq:
	TMP0
	TMP1
	SRC2 TMP0		# copy SRC2 to TMP1
	TMP0 TMP1
beq-check-one:
	SRC1 SRC2 beq-check-two
	TMP0 TMP0 beq-no-jump-two # NO
beq-check-two:	
	TMP1 SRC1 beq-jump	# test if SRC1 <= SRC2
beq-no-jump-two:
	NEXT RVPC END    		# goto next instruction
beq-jump:
	TMP0
	IMMI TMP0       		# YES
	TMP0 RVPC END    		# pc + B_imm

@BNE # 57 // 111001
bne:
	TMP0
	TMP1
	SRC2 TMP0		# copy SRC2 to TMP1
	TMP0 TMP1
	SRC1 SRC2 bne-check-two	# test if SRC2 <= SRC1
	TMP0 TMP0 bne-jump
bne-check-two:
	TMP1 SRC1 bne-no-jump   # test if SRC1 <= SRC2
bne-jump:
	TMP2
	IMMI TMP2
	TMP2 RVPC END
bne-no-jump:	
	NEXT RVPC END

@BLTU # 79 // 1001111
	TMP0
	TMP1
	SRC1 TMP0 bltu-one-small # check if SRC1 >= 0
	SRC2 TMP1 blt-jump # check if SRC2 >= 0, if so then perform jump because SRC2 < SRC1
	TMP1 TMP1 blt # now do normal blt instruction
bltu-one-small:
	SRC2 TMP1 blt # check if SRC2 >= 0, if not then perform no jump
	TMP1 TMP1 blt-no-jump # SRC2 > SRC1	

@BLT # 68 // 1000100
blt:
	# check src2 <= src1
	SRC2 SRC1 blt-no-jump
blt-jump:
	TMP0
	# no jump src2 >= src1
	IMMI TMP0
	TMP0 RVPC END
blt-no-jump:
    	# src1 < src2 jump
	NEXT RVPC END

@BGEU # 79 // 1001111
	TMP0
	TMP1
	SRC1 TMP0 bgeu-one-small # check if SRC1 >= 0
	SRC2 TMP1 bge-no-jump # check if SRC2 >= 0, if so then perform no jump because SRC2 < SRC1
	TMP1 TMP1 bge # now do normal blt instruction
bgeu-one-small:
	SRC2 TMP1 bge # check if SRC2 >= 0, if not then perform jump
	TMP1 TMP1 bge-jump # SRC2 > SRC1

@BGE # 74 // 1001010
bge:
	# check src2 <= src1
	SRC2 SRC1 bge-jump
bge-no-jump:
	# no jump src2 >= src1
	NEXT RVPC END
bge-jump:
	# src1 < src2 jump
	TMP0
	IMMI TMP0
	TMP0 RVPC END

# ============================================================
#                         BIT LOGIC
# ============================================================
@XORI
@XOR # 135 // 10000111
	TMP0
    TMP5
    SRC1
    SRC2 TMP0
    TMP0 SRC1
    SRC2
    WORD TMP5
xor-loop:
    TMP0
    SRC2 TMP0
    TMP0 SRC2
xor-get-msb-src-one:
    TMP0
    SRC1 TMP0 xor-must-be-one
xor-must-be-zero:
    TMP0
    IMMI TMP0 xor-set-bit
    TMP0 TMP0 xor-shift
xor-must-be-one:
    TMP0
    IMMI TMP0 xor-shift
xor-set-bit:
    INCR SRC2
xor-shift:
    TMP0
    SRC1 TMP0
    TMP0 SRC1
    TMP0
    IMMI TMP0
    TMP0 IMMI
    INCR TMP5 xor-loop
xor-clean:
    NEXT RVPC END

@ORI
@OR # 161 // 10100001
	TMP0
    TMP5
    SRC1
    SRC2 TMP0
    TMP0 SRC1
    SRC2
    WORD TMP5
or-loop:
    TMP0
    SRC2 TMP0
    TMP0 SRC2
or-get-msb-src-one:
    TMP0
    SRC1 TMP0 or-get-msb-src-two
    TMP0 TMP0 or-set-bit
or-get-msb-src-two:
    TMP0
    IMMI TMP0 or-shift
or-set-bit:
    INCR SRC2
or-shift:
    TMP0
    SRC1 TMP0
    TMP0 SRC1
    TMP0
    IMMI TMP0
    TMP0 IMMI
    TMP0
    INCR TMP5 or-loop
or-clean:
    NEXT RVPC END

@ANDI
@AND # 186 // 10111010
	TMP0
    TMP3
    TMP5
    SRC1
    SRC2 TMP0
    TMP0 SRC1
    SRC2
    WORD TMP5
and-loop:
    TMP3
    SRC2 TMP3
    TMP3 SRC2
and-get-msb-src-one:
    TMP0
    SRC1 TMP0 and-shift
and-get-msb-src-two:
    TMP0
    IMMI TMP0 and-shift
and-set-bit:
    INCR SRC2
and-shift:
    TMP3
    SRC1 TMP3
    TMP3 SRC1
    TMP3
    IMMI TMP3
    TMP3 IMMI
    INCR TMP5 and-loop
and-clean:
    NEXT RVPC END

# ============================================================
#                         SHIFTING
# ============================================================
@SLLI
@SLL # 210 // 11010010
	TMP0
	TMP1
	SRC2 TMP1
	SRC2
	IMMI TMP0 sll-shift	# -IMMI -> TMP0
sll-loop:    
	SRC2 TMP1		# negate shift value
sll-shift:	
	TMP1 SRC2     	        # SRC2 + SRC2
	TMP1			# reset TMP1
	INCR TMP0 sll-loop	# loop
sll-clean:    
	NEXT RVPC END		# next RISC-V

@SRAI
@SRA # 220 // 11011100
	TMP0
	SRC1
	SRC2 TMP0 sra-is-pos
	TMP0 SRC1
	SRC2
sra-is-neg:			# set SRC2 to -1 to sign extend
	ONE SRC2
	TMP0 TMP0 srl
sra-is-pos:

@SRLI
@SRL # 226 // 11100010
srl-setup:
	TMP0
	SRC1
	SRC2 TMP0
	TMP0 SRC1
	SRC2
	TMP0
srl:
	TMP5
	WORD TMP5
	IMMI TMP0
	TMP0 TMP5
srl-msb-check:
	TMP0
	SRC1 TMP0 srl-msb-unset
srl-msb-set:	
	TMP0
	SRC2 TMP0	# SRC2 <<1
	TMP0 SRC2	# SRC2 <<1	
	INCR SRC2	# set bit of SRC2
	TMP0 TMP0 srl-check-loop
srl-msb-unset:
	TMP0
	SRC2 TMP0	# SRC2 <<1
	TMP0 SRC2	# SRC2 <<1	
srl-check-loop:
	TMP0
	TMP5 TMP0 srl-end	
srl-move-op:
	TMP0
	SRC1 TMP0
	TMP0 SRC1
	INCR TMP5	
	TMP0 TMP0 srl-msb-check	
srl-end:
	NEXT RVPC END



# ============================================================
#                         SET BIT
# ============================================================
@SLTIU
	TMP0
	SRC1
	IMMI TMP0
	TMP0 SRC1
@SLTU # 259 // 100000011
	TMP0
	TMP1
	SRC1 TMP0 sltu-one-small # check if SRC1 >= 0
	SRC2 TMP1 slt-set # check if SRC2 >= 0, if so then perform jump because SRC2 < SRC1
	TMP1 TMP1 slt-check-one # now do normal blt instruction
sltu-one-small:
	SRC2 TMP1 slt-check-one # check if SRC2 >= 0, if not then perform no jump
	TMP1 TMP1 slt-no-set # SRC2 > SRC1	

@SLTI
@SLT # 253 // 11111101
slt-check-one:
	SRC2 IMMI slt-no-set
slt-set:    
	SRC2
	INCR SRC2
	NEXT RVPC END
slt-no-set:
	SRC2
	NEXT RVPC END