#lang rosette

(require "model.rkt")
(require "util.rkt")
(require "verify.rkt")
(require "microcode.rkt")

(output-smt #f)

(require rosette/solver/smt/boolector)
(require rosette/solver/smt/cvc4)
(require rosette/solver/smt/z3)

(rv-verify
  #:name "ADD"
  #:init-pc ADD-PC
  #:fuel 4
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (list-ref res 1) (bvadd val-immi val-src1))))
  #:assumptions #f)
  
(rv-verify
  #:name "ADDI"
  #:init-pc ADDI-PC
  #:fuel 4
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (list-ref res 1) (bvadd val-immi val-src1))))
  #:assumptions #f)

(rv-verify
  #:name "LB"
  #:init-pc LB-PC
  #:fuel 4
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref (verify-memory res) 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (verify-result res) (bvadd val-immi val-src1))))
  #:assumptions #f)  

(rv-verify
  #:name "LH"
  #:init-pc LH-PC
  #:fuel 4
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref (verify-memory res) 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (verify-result res) (bvadd val-immi val-src1))))
  #:assumptions #f)  

(rv-verify
  #:name "LW"
  #:init-pc LW-PC
  #:fuel 4
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref (verify-memory res) 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (verify-result res) (bvadd val-immi val-src1))))
  #:assumptions #f)

(rv-verify
  #:name "LBU"
  #:init-pc LBU-PC
  #:fuel 4
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref (verify-memory res) 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (verify-result res) (bvadd val-immi val-src1))))
  #:assumptions #f)

(rv-verify
  #:name "LHU"
  #:init-pc LBU-PC
  #:fuel 4
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref (verify-memory res) 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (verify-result res) (bvadd val-immi val-src1))))
  #:assumptions #f)

(rv-verify
  #:name "SB"
  #:init-pc SB-PC
  #:fuel 4
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref (verify-memory res) 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (verify-result res) (bvadd val-immi val-src1))))
  #:assumptions #f)

(rv-verify
  #:name "SH"
  #:init-pc SH-PC
  #:fuel 4
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref (verify-memory res) 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (verify-result res) (bvadd val-immi val-src1))))
  #:assumptions #f)

(rv-verify
  #:name "SW"
  #:init-pc SW-PC
  #:fuel 4
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref (verify-memory res) 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (verify-result res) (bvadd val-immi val-src1))))
  #:assumptions #f)

 (rv-verify
  #:name "SUB"
  #:init-pc SUB-PC
  #:fuel 2
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (list-ref res 1) (bvsub val-src1 val-immi))))
  #:assumptions #f)

 (rv-verify
  #:name "AUIPC"
  #:init-pc AUIPC-PC
  #:fuel 8
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (list-ref res 1) (bvadd val-rvpc val-immi))))
  #:assumptions #f)

 (rv-verify
  #:name "LUI"
  #:init-pc LUI-PC
  #:fuel 4
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (list-ref res 1) (bvadd val-immi val-src1))))
  #:assumptions #f)

 (rv-verify
  #:name "JAL"
  #:init-pc JAL-PC
  #:fuel 8
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc val-immi))
                (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))))
  #:assumptions (λ (mem)
                  (assume (eq? (bv 0 2) (extract 1 0 (list-ref mem 1))))))

 (rv-verify
  #:name "JALR"
  #:init-pc JALR-PC
  #:fuel (+ 23 (* 4 XLEN))
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
          (and 
			(eq? (list-ref (list-ref res 0) 1) (bvand (bvadd val-src1 val-immi) (bvnot (bv 1 XLEN))))
               (bveq (lsb (list-ref (list-ref res 0) 1)) (bv 0 1))
               ;;(eq? (bv 0 2) (extract 1 0 (list-ref (list-ref res 0) 1)))
               (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))))
  #:assumptions #f)

 (rv-verify
  #:name "BEQ"
  #:init-pc BEQ-PC
  #:fuel 9
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (if (bveq val-src1 val-src2)
               (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc val-immi))
               (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc (bv 4 XLEN)))))
  #:assumptions #f)

 (rv-verify
  #:name "BNE"
  #:init-pc BNE-PC
  #:fuel 9
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (if (bveq val-src1 val-src2)
               (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc (bv 4 XLEN)))
               (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc val-immi))))
  #:assumptions #f)

 (rv-verify
  #:name "BLT"
  #:init-pc BLT-PC
  #:fuel 4
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (if (bvslt val-src1 val-src2)
               (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc val-immi))
               (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc (bv 4 XLEN)))))
  #:assumptions #f)

 (rv-verify
  #:name "BLTU"
  #:init-pc BLTU-PC
  #:fuel 9
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (if (bvult val-src1 val-src2)
               (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc val-immi))
               (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc (bv 4 XLEN)))))
  #:assumptions #f)

 (rv-verify
  #:name "BGE"
  #:init-pc BGE-PC
  #:fuel 4
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (if (bvsge val-src1 val-src2)
               (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc val-immi))
               (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc (bv 4 XLEN)))))
  #:assumptions #f)

 (rv-verify
  #:name "BGEU"
  #:init-pc BGEU-PC
  #:fuel 9
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (if (bvuge val-src1 val-src2)
               (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc val-immi))
               (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc (bv 4 XLEN)))))
  #:assumptions #f)

 (rv-verify
  #:name "SLTI"
  #:init-pc SLTI-PC
  #:fuel 6
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (list-ref res 1) (if (bvslt val-src1 val-immi) (bv 1 XLEN) (bv 0 XLEN)))))
  #:assumptions #f)

 (rv-verify
  #:name "SLTIU"
  #:init-pc SLTIU-PC
  #:fuel 13
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (list-ref res 1) (if (bvult val-src1 val-immi) (bv 1 XLEN) (bv 0 XLEN)))))
  #:assumptions #f)

 (rv-verify
  #:name "SLLI"
  #:init-pc SLLI-PC
  #:fuel (+ (* 4 XLEN) 7)
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (list-ref res 1) (bvshl val-src1 val-immi))))
  #:assumptions (λ (mem) ;; restrict shift amount for sll/slli/srl/srli
                  (assume
                   (bvult (list-ref mem 8) (bv XLEN XLEN)))))

 (rv-verify
  #:name "SRLI"
  #:init-pc SRLI-PC
  #:fuel (+ (* 14 XLEN) 10)
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (list-ref res 1) (bvlshr val-src1 val-immi))))
  #:assumptions (λ (mem) ;; restrict shift amount for sll/slli/srl/srli
                  (assume
                   (bvult (list-ref mem 8) (bv (- XLEN 1) XLEN)))))

 (rv-verify
  #:name "SRAI"
  #:init-pc SRAI-PC
  #:fuel (+ (* 14 XLEN) 13)
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (list-ref res 1) (bvashr val-src1 val-immi))))
  #:assumptions (λ (mem) ;; restrict shift amount for sll/slli/srl/srli
                  (assume
                   (bvult (list-ref mem 8) (bv (- XLEN 1) XLEN)))))

(rv-verify
 #:name "XORI"
 #:init-pc XORI-PC
 #:fuel (+ 6 (* 15 XLEN))
 #:microcode microcode
 #:solver (boolector)
 #:spec (λ (res)
          (and (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc (bv 4 XLEN)))
               (eq? (list-ref res 1) (bvxor val-src1  val-immi))))
 #:assumptions #f)

(rv-verify
 #:name "ANDI"
 #:init-pc ANDI-PC
 #:fuel (+ 6 (* 15 XLEN))
 #:microcode microcode
 #:solver (boolector)
 #:spec (λ (res)
          (and (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc (bv 4 XLEN)))
               (eq? (list-ref res 1) (bvand val-src1 val-immi))))
 #:assumptions #f)

(rv-verify
 #:name "ORI"
 #:init-pc ORI-PC
 #:fuel (+ 6 (* 15 XLEN))
 #:microcode microcode
 #:solver (boolector)
 #:spec (λ (res)
          (and (eq? (list-ref (list-ref res 0) 1) (bvadd val-rvpc (bv 4 XLEN)))
               (eq? (list-ref res 1) (bvor val-src1 val-immi))))
 #:assumptions #f)
