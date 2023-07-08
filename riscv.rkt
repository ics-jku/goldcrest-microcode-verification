#lang rosette

(require "model.rkt")
(require "util.rkt")
(require "verify.rkt")
(require "compliant.rkt")

(output-smt #f)

(require rosette/solver/smt/boolector)
(require rosette/solver/smt/cvc4)
(require rosette/solver/smt/z3)

 (rv-verify
  #:name "ADDI"
  #:init-pc ADDI-PC
  #:fuel 5
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (list-ref res 4) (bvadd val-immi val-src2))))
  #:assumptions #f)

 (rv-verify
  #:name "SUB"
  #:init-pc SUB-PC
  #:fuel 9
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (list-ref res 4) (bvsub val-src2 val-immi))))
  #:assumptions #f)

 (rv-verify
  #:name "AUIPC"
  #:init-pc AUIPC-PC
  #:fuel 10
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (list-ref res 4) (bvadd val-rvpc val-immi))))
  #:assumptions #f)

 (rv-verify
  #:name "LUI"
  #:init-pc LUI-PC
  #:fuel 10
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (list-ref res 4) (bvadd val-immi val-src2))))
  #:assumptions #f)

 (rv-verify
  #:name "JAL"
  #:init-pc JAL-PC
  #:fuel 20
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref res 1) (bvadd val-rvpc val-immi))
                (eq? (list-ref res 4) (bvadd val-rvpc (bv 4 XLEN)))))
  #:assumptions (λ (res)
                  (assume (eq? (bv 0 2) (extract 1 0 (list-ref res 1))))))

 (rv-verify
  #:name "JALR"
  #:init-pc JALR-PC
  #:fuel (+ 25 (* 4 XLEN))
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
          (and 
			(eq? (list-ref res 1) (bvand (bvadd val-src2 val-immi) (bvnot (bv 1 XLEN))))
               (bveq (lsb (list-ref res 1)) (bv 0 1))
               ;;(eq? (bv 0 2) (extract 1 0 (list-ref res 1)))
               (eq? (list-ref res 4) (bvadd val-rvpc (bv 4 XLEN)))))
  #:assumptions #f)

 (rv-verify
  #:name "BEQ"
  #:init-pc BEQ-PC
  #:fuel 20
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (if (bveq val-src1 val-src2)
               (eq? (list-ref res 1) (bvadd val-rvpc val-immi))
               (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))))
  #:assumptions #f)

 (rv-verify
  #:name "BNE"
  #:init-pc BNE-PC
  #:fuel 20
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (if (bveq val-src1 val-src2)
               (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))
               (eq? (list-ref res 1) (bvadd val-rvpc val-immi))))
  #:assumptions #f)

 (rv-verify
  #:name "BLT"
  #:init-pc BLT-PC
  #:fuel 20
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (if (bvslt val-src2 val-src1)
               (eq? (list-ref res 1) (bvadd val-rvpc val-immi))
               (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))))
  #:assumptions #f)

 (rv-verify
  #:name "BLTU"
  #:init-pc BLTU-PC
  #:fuel (+ 10 (* 19 XLEN))
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (if (bvult val-src2 val-src1)
               (eq? (list-ref res 1) (bvadd val-rvpc val-immi))
               (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))))
  #:assumptions #f)

 (rv-verify
  #:name "BGE"
  #:init-pc BGE-PC
  #:fuel 20
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (if (bvsge val-src2 val-src1)
               (eq? (list-ref res 1) (bvadd val-rvpc val-immi))
               (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))))
  #:assumptions #f)

 (rv-verify
  #:name "BGEU"
  #:init-pc BGEU-PC
  #:fuel (+ 10 (* 19 XLEN))
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (if (bvuge val-src2 val-src1)
               (eq? (list-ref res 1) (bvadd val-rvpc val-immi))
               (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))))
  #:assumptions #f)

 (rv-verify
  #:name "SLTI"
  #:init-pc SLTI-PC
  #:fuel 10
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (list-ref res 4) (if (bvslt val-src2 val-immi) (bv 1 XLEN) (bv 0 XLEN)))))
  #:assumptions #f)

 (rv-verify
  #:name "SLTIU"
  #:init-pc SLTIU-PC
  #:fuel 200
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (list-ref res 4) (if (bvult val-src2 val-immi) (bv 1 XLEN) (bv 0 XLEN)))))
  #:assumptions #f)

 (rv-verify
  #:name "SLLI"
  #:init-pc SLLI-PC
  #:fuel (+ (* 4 XLEN) 10)
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (list-ref res 4) (bvshl val-src2 val-immi))))
  #:assumptions (λ (mem) ;; restrict shift amount for sll/slli/srl/srli
                  (assume
                   (bvult (list-ref mem 8) (bv XLEN XLEN)))))

 (rv-verify
  #:name "SRLI"
  #:init-pc SRLI-PC
  #:fuel 150
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (list-ref res 4) (bvlshr val-src2 val-immi))))
  #:assumptions (λ (mem) ;; restrict shift amount for sll/slli/srl/srli
                  (assume
                   (bvult (list-ref mem 8) (bv (- XLEN 1) XLEN)))))

 (rv-verify
  #:name "SRAI"
  #:init-pc SRAI-PC
  #:fuel 150
  #:microcode microcode
  #:solver (boolector)
  #:spec (λ (res)
           (and (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))
                (eq? (list-ref res 4) (bvashr val-src2 val-immi))))
  #:assumptions (λ (mem) ;; restrict shift amount for sll/slli/srl/srli
                  (assume
                   (bvult (list-ref mem 8) (bv (- XLEN 1) XLEN)))))

(rv-verify
 #:name "XORI"
 #:init-pc XORI-PC
 #:fuel (+ 15 (* 18 XLEN))
 #:microcode microcode
 #:solver (boolector)
 #:spec (λ (res)
          (and (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))
               (eq? (list-ref res 4) (bvxor val-src2  val-immi))))
 #:assumptions #f)

(rv-verify
 #:name "ANDI"
 #:init-pc ANDI-PC
 #:fuel (+ 15 (* 15 XLEN))
 #:microcode microcode
 #:solver (boolector)
 #:spec (λ (res)
          (and (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))
               (eq? (list-ref res 4) (bvand val-src2 val-immi))))
 #:assumptions #f)

(rv-verify
 #:name "ORI"
 #:init-pc ORI-PC
 #:fuel (+ 15 (* 17 XLEN))
 #:microcode microcode
 #:solver (boolector)
 #:spec (λ (res)
          (and (eq? (list-ref res 1) (bvadd val-rvpc (bv 4 XLEN)))
               (eq? (list-ref res 4) (bvor val-src2 val-immi))))
 #:assumptions #f)
