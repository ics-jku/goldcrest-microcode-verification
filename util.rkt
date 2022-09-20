#lang rosette

(require "model.rkt")

(define (disassemble code)
  (define (display-src src)
    (cond
      [(= src 0) "  TMP0"]
      [(= src 1) "  RVPC"]
      [(= src 2) "  SRC1"]
      [(= src 3) "  TMP1"]
      [(= src 4) "  SRC2"]
      [(= src 5) "  TMP2"]
      [(= src 6) "  TMP3"]
      [(= src 7) "  TMP4"]
      [(= src 8) "  IMMI"]
      [(= src 9) "  TMP5"]
      [(= src 10) "   ONE"]
      [(= src 11) "  WORD"]
      [(= src 12) "   INC"]
      [(= src 13) "  NEXT"]
      [(= src 14) "  TMP6"]
      [(= src 15) "  TMP7"]
      [else (~a src #:min-width 6 #:align 'right #:left-pad-string " ")]))
  
  (define (display-jump jump)
    (cond
      [(= jump 1) "  STEP"]
      [(= jump 255) "  EXIT"]
      [else (~a jump #:min-width 6 #:align 'right #:left-pad-string " ")]))
  
  (for ([instr code])
    (printf "~a ~a ~a\n"
	    (display-src (bitvector->natural (extract 15 12 instr)))
    	    (display-src (bitvector->natural (extract 11 8 instr)))
            (display-jump (bitvector->integer (extract 7 0 instr))))))

(define (disassemble-to-scala code)
  (define (display-src src)
    (cond
      [(= src 0) "SRC1"]
      [(= src 1) "SRC2"]
      [(= src 2) "TMP0"]
      [(= src 3) "TMP1"]
      [(= src 4) "INCR"]
      [(= src 5) "DECR"]
      [else (~a src #:min-width 6 #:align 'right #:left-pad-string " ")]))
  (define (display-jump jump)
    (cond
      [(= jump 1) "NEXT"]
      [(= jump 7) "STOP"]
      [else (~a jump #:min-width 6 #:align 'right #:left-pad-string " ")]))
  (for ([instr code])
    (if (bveq (extract 3 0 instr) (bv 1 4))
        (printf "subleq(~a, ~a)\n"      
            (display-src (bitvector->natural (extract 9 7 instr)))
            (display-src (bitvector->natural (extract 6 4 instr))))
        (printf "subleq(~a, ~a, ~a)\n"      
                (display-src (bitvector->natural (extract 9 7 instr)))
                (display-src (bitvector->natural (extract 6 4 instr)))
                (display-jump (bitvector->integer (extract 3 0 instr)))))))

(define-syntax-rule (sbv val) (bv val XLEN))

(provide disassemble disassemble-to-scala sbv)
