! Compliant                             
# ============================================================
#                         ARITHMETIC
# ============================================================
@ADD                                    
@ADDI                                   
@LUI                                    
    TMP0                                
    IMMI TMP0                           # negate IMMI   | TMP0 - IMMI = 0 - mem[IMMI]
    NEXT RVPC                           # increment RISC-V pc
    TMP0 SRC2  END                      # SRC2 - -(TMP0)
                                        
@SUB                                    
    NEXT RVPC                           # increment RISC-V pc
    IMMI SRC2  END 
                                        
@AUIPC                                  
    TMP0                                
    SRC2                                
    RVPC TMP0                           # copy RVPC to SRC2
    TMP0 SRC2                           
    TMP0                                # RVPC + IMMI
    IMMI TMP0                           
    NEXT RVPC                           
    TMP0 SRC2  END                      
                                        
# ============================================================
#                         JUMPS
# ============================================================
@LB                                     
@LH                                     
@LW                                     
@LBU                                    
@LHU                                    
@SB                                     
@SH                                     
@SW                                     
    TMP0                                
    IMMI TMP0                           # negate IMMI   | TMP0 - IMMI = 0 - mem[IMMI]
    NEXT RVPC                           # increment RISC-V pc
    TMP0 SRC1  END                      # SRC1 - -(TMP0)
                                        
# ============================================================
#                         JUMPS
# ============================================================
@JAL                                    
    TMP0                                
    TMP1                                
    SRC2                                # reset SRC2
    IMMI TMP0                           # negate IMMI
    RVPC TMP1                           # -pc => TMP1
    TMP0 RVPC                           # RVPC - -TMP0
    TMP1 SRC2                           # pc => SRC2
    NEXT SRC2  END                      # add link address +4
                                        
@JALR                                   
    TMP0                                # reset TMP0
    TMP1                                # reset TMP1
    TMP2                                # reset TMP2
    TMP3                                # reset TMP3
    SRC2 TMP1                           # -SRC2 => TMP1   calculate jump target
    TMP1 IMMI                           # IMMI --(SRC2)
    TMP1                                # reset TMP1    set new pc after jump
jalr-prep:                              
    WORD TMP0                           
    INCR TMP0                           
    IMMI TMP3                           # save IMMI
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
    IMMI TMP1                           # -(SRC2 + IMMI) => TMP1
    NEXT RVPC                           # RVPC + 4
    TMP0                                
    RVPC TMP0                           # -(RVPC + 4) store link pc
    RVPC                                # reset RVPC
    TMP1 RVPC                           # (SRC2 + IMMI) => RVPC
    SRC2                                # reset SRC2
    TMP0 SRC2  END                      # (RVPC + 4) => SRC2
                                        
# ============================================================
#                         BRANCHES
# ============================================================
@BEQ                                    
beq:                                    
    TMP0                                
    TMP1                                
    SRC2 TMP0                           # copy SRC2 to TMP1
    TMP0 TMP1                           
beq-check-one:                          
    SRC1 SRC2 beq-check-two             
    TMP0 TMP0 beq-no-jump-two           # NO
beq-check-two:                          
    TMP1 SRC1 beq-jump                  # test if SRC1 <= SRC2
beq-no-jump-two:                        
    NEXT RVPC  END                      # goto next instruction
beq-jump:                               
    TMP0                                
    IMMI TMP0                           # YES
    TMP0 RVPC  END                      # pc + B_imm
                                        
@BNE                                    
bne:                                    
    TMP0                                
    TMP1                                
    SRC2 TMP0                           # copy SRC2 to TMP1
    TMP0 TMP1                           
    SRC1 SRC2 bne-check-two             # test if SRC2 <= SRC1
    TMP0 TMP0 bne-jump                  
bne-check-two:                          
    TMP1 SRC1 bne-no-jump               # test if SRC1 <= SRC2
bne-jump:                               
    TMP2                                
    IMMI TMP2                           
    TMP2 RVPC  END                      
bne-no-jump:                            
    NEXT RVPC  END                      
                                        
@BLTU                                   
    TMP0                                
    TMP1                                
    SRC1 TMP0 bltu-one-small            # check if SRC1 >= 0
    SRC2 TMP1 blt-jump                  # check if SRC2 >= 0, if so then perform jump because SRC2 < SRC1
    TMP1 TMP1  blt                      # now do normal blt instruction
bltu-one-small:                         
    SRC2 TMP1  blt                      # check if SRC2 >= 0, if not then perform no jump
    TMP1 TMP1 blt-no-jump               # SRC2 > SRC1
                                        
@BLT                                    # 68 // 1000100
blt:                                    
# check src2 <= src1
    SRC2 SRC1 blt-no-jump               
blt-jump:                               
    TMP0                                
# no jump src2 >= src1
    IMMI TMP0                           
    TMP0 RVPC  END                      
blt-no-jump:                            
# src1 < src2 jump
    NEXT RVPC  END                      
                                        
@BGEU                                   
    TMP0                                
    TMP1                                
    SRC1 TMP0 bgeu-one-small            # check if SRC1 >= 0
    SRC2 TMP1 bge-no-jump               # check if SRC2 >= 0, if so then perform no jump because SRC2 < SRC1
    TMP1 TMP1  bge                      # now do normal blt instruction
bgeu-one-small:                         
    SRC2 TMP1  bge                      # check if SRC2 >= 0, if not then perform jump
    TMP1 TMP1 bge-jump                  # SRC2 > SRC1
                                        
@BGE                                    
bge:                                    
# check src2 <= src1
    SRC2 SRC1 bge-jump                  
bge-no-jump:                            
# no jump src2 >= src1
    NEXT RVPC  END                      
bge-jump:                               
# src1 < src2 jump
    TMP0                                
    IMMI TMP0                           
    TMP0 RVPC  END                      
                                        
# ============================================================
#                         BIT LOGIC
# ============================================================
@XORI                                   
@XOR                                    
    TMP2                                
    WORD TMP2                           
    TMP1 TMP1 xor-get-msb-src-one       
xor-loop:                               
    TMP0                                
    TMP1 TMP0                           
    TMP0 TMP1                           
xor-get-msb-src-one:                    
    TMP0                                
    SRC2 TMP0 xor-must-be-one           
xor-must-be-zero:                       
    TMP0                                
    IMMI TMP0 xor-set-bit               
    TMP0 TMP0 xor-shift-two             
xor-must-be-one:                        
    TMP0                                
    IMMI TMP0 xor-shift                 
xor-set-bit:                            
    INCR TMP1                           
xor-shift:                              
    TMP0                                
xor-shift-two:                          
    SRC2 TMP0                           
    TMP0 SRC2                           
    TMP0                                
    IMMI TMP0                           
    TMP0 IMMI                           
    INCR TMP2 xor-loop                  
xor-clean:                              
    NEXT RVPC                           
    TMP0                                
    TMP0 TMP1  END                      
                                        
@ORI                                    
@OR                                     
    TMP2                                
    WORD TMP2                           
    TMP1 TMP1 or-get-msb-src-two        
or-loop:                                
    TMP0                                
    TMP1 TMP0                           
    TMP0 TMP1                           
or-get-msb-src-two:                     
    TMP0                                
    SRC2 TMP0 or-get-msb-immi           
or-set-bit:                             
    INCR TMP1                           
    TMP0 TMP0 or-shift-two              
or-get-msb-immi:                        
    TMP0                                
    IMMI TMP0 or-shift                  
or-set-bit-two:                         
    INCR TMP1                           
or-shift:                               
    TMP0                                
or-shift-two:                           
    SRC2 TMP0                           
    TMP0 SRC2                           
    TMP0                                
    IMMI TMP0                           
    TMP0 IMMI                           
    INCR TMP2 or-loop                   
or-clean:                               
    NEXT RVPC                           
    TMP0                                
    TMP0 TMP1  END                      
                                        
@ANDI                                   
@AND                                    
    TMP2                                
    WORD TMP2                           
    TMP1 TMP1 and-get-msb-src-two       
and-loop:                               
    TMP0                                
    TMP1 TMP0                           
    TMP0 TMP1                           
and-get-msb-src-two:                    
    TMP0                                
    SRC2 TMP0 and-shift                 
and-get-msb-immi:                       
    TMP0                                
    IMMI TMP0 and-shift                 
and-set-bit:                            
    INCR TMP1                           
and-shift:                              
    TMP0                                
    SRC2 TMP0                           
    TMP0 SRC2                           
    TMP0                                
    IMMI TMP0                           
    TMP0 IMMI                           
    INCR TMP2 and-loop                  
and-clean:                              
    NEXT RVPC                           
    TMP0                                
    TMP0 TMP1  END                      
                                        
# ============================================================
#                         SHIFTING
# ============================================================
@SLLI                                   
@SLL                                    
    TMP0                                
    TMP1                                
    SRC2 TMP1                           
    SRC2                                
    IMMI TMP0 sll-check                 # -IMMI -> TMP0
sll-loop:                               
    TMP1 SRC2                           # SRC2 + SRC2
    TMP1                                # reset TMP1
    SRC2 TMP1                           # negate shift value
sll-check:                              
    INCR TMP0 sll-loop                  # loop
sll-clean:                              
    NEXT RVPC                           # next RISC-V
    TMP1 SRC2  END                      # SRC2 + SRC2
                                        
@SRAI                                   
@SRA                                    
    TMP0                                
    SRC1                                
    SRC2 TMP0 sra-is-pos                
    TMP0 SRC1                           
    SRC2                                
sra-is-neg:                             # set SRC2 to -1 to sign extend
    CONE SRC2                           
    TMP0 TMP0  srl                      
sra-is-pos:                             
                                        
@SRLI                                   
@SRL                                    
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
    SRC2 TMP0                           # SRC2 <<1
    TMP0 SRC2                           # SRC2 <<1
    INCR SRC2                           # set bit of SRC2
    TMP0 TMP0 srl-check-loop            
srl-msb-unset:                          
    TMP0                                
    SRC2 TMP0                           # SRC2 <<1
    TMP0 SRC2                           # SRC2 <<1
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
    NEXT RVPC                           
    TMP0                                
    TMP0 SRC2  END                      
                                        
                                        
                                        
# ============================================================
#                         SET BIT
# ============================================================
@SLTIU                                  
@SLTU                                   
    TMP0                                
    TMP1                                
    IMMI TMP0 sltu-one-small            # check if IMMI >= 0
    TMP0                                
    SRC2 TMP0 slt-set                   # check if SRC2 >= 0, if so then perform jump because SRC2 < SRC1
    TMP0 TMP0 slt-check-one             # now do normal blt instruction
sltu-one-small:                         
    TMP0                                
    SRC2 TMP0 slt-check-one             # check if SRC2 >= 0, if not then perform no jump
    TMP0 TMP0 slt-no-set                # SRC2 > SRC1
                                        
@SLTI                                   
@SLT                                    
slt:                                    
    TMP1                                
slt-check-one:                          
    SRC2 IMMI slt-no-set                
slt-set:                                
    CONE TMP1                           
slt-no-set:                             
    TMP0                                
    NEXT RVPC                           
    TMP1 TMP0  END                      
