#lang rosette

(require racket/cmdline)

(define XLEN (let ([args (current-command-line-arguments)])
  (if (> (vector-length args) 0)
      (string->number (vector-ref args 0))
      32)))

(define-syntax-rule (get-src1 code) (first code))
(define-syntax-rule (get-src2 code) (second code))
(define-syntax-rule (get-jump code) (third code))

(define-values (TMP0 RVPC SRC1 TMP1 SRC2 TMP2 TMP3 TMP4 IMMI TMP5 CONE WORD INCR NEXT TMP6 TMP7)
  (values (bv 0 4) (bv 1 4) (bv 2 4) (bv 3 4)
          (bv 4 4) (bv 5 4) (bv 6 4) (bv 7 4)
          (bv 8 4) (bv 9 4) (bv 10 4) (bv 11 4)
          (bv 12 4) (bv 13 4) (bv 14 4) (bv 15 4)))

(define IMM IMMI)
(define PC RVPC)
(define TWO TMP6)
(define ONE CONE)
(define INC INCR)
(define RSLT SRC2)

(define-values (STEP EXIT)
  (values (bv 1 9) (bv -1 9)))

(define (subleq src1 src2 jump) (concat src1 src2 jump))

(define (memory-ref memory idx) (list-ref-bv memory idx))

(define (execute start-fuel code start-memory (init-pc (bv 0 9)))
  ;; Initialize Subleq Registers (see table)
  ;; Memory == Subleq registers
  (assume (and          
           (eq? (list-ref start-memory 10) (bv 1 XLEN))
           (eq? (list-ref start-memory 11) (bv (- XLEN 1) XLEN))
           (eq? (list-ref start-memory 12) (bv -1 XLEN))
           (eq? (list-ref start-memory 13) (bv -4 XLEN))
           ;; (eq? (list-ref start-memory 14) (bv 2 XLEN))
           (eq? (extract 1 0 (list-ref start-memory 1)) (bv 0 2)))) ;; check that rv pc is word aligned
  (define (step fuel mpc memory) ;; fuel is the current unroll depth
    (cond [(= fuel 0) "no solution in runtime"] ;; if fuel reaches 0 no solution found, fuel-- on each iteration
          [else
           (define instr (list-ref-bv code mpc)) ;; fetch current SUBLEQ instruction
           (define src1 (extract 15 12 instr))
           (define src2 (extract 11 8 instr))
           (define jump
             (sign-extend (extract 7 0 instr) (bitvector 9))) ;; jump offset if src2 - src1 <= 0
           (define val1
             (sign-extend (list-ref-bv memory src1) (bitvector (+ 1 XLEN)))) ;; get argument values from mem and do sign extension to handle overflow
           (define val2
             (sign-extend (list-ref-bv memory src2) (bitvector (+ 1 XLEN))))
           (define res (bvsub val2 val1))
           (define new-memory
             (for/list [(index (range 16))]
               (if (bveq (integer->bitvector index (bitvector 4)) src2)
                   (extract (- XLEN 1) 0 res)
                   (list-ref memory index))))
           (define new-pc (if (bvsle res (bv 0 (+ 1 XLEN))) (bvadd mpc jump) (bvadd mpc STEP)))
           (define do-jump (bvslt res (bv 0 (+ 1 XLEN))))
           (if (bveq jump EXIT)
               (list new-memory (extract (- XLEN 1) 0 res))
               (step (- fuel 1) new-pc new-memory))]))
  (step start-fuel init-pc start-memory))

(provide subleq execute memory-ref TMP0 RVPC  SRC1 TMP1 SRC2 TMP2 TMP3 TMP4 IMMI TMP5 ONE CONE WORD INC INCR NEXT TMP6 TMP7 STEP EXIT XLEN RSLT IMM PC TWO RSLT)
