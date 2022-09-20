#lang rosette

(require "model.rkt")
(require "util.rkt")

(define-symbolic val-tmp0 val-rvpc val-src1 val-tmp1 val-src2 val-tmp2 val-tmp3 val-tmp4 val-immi val-tmp5 val-one val-word val-inc val-step val-tmp6 val-tmp7 (bitvector XLEN))

(define test-mem
  (list val-tmp0
        val-rvpc
        val-src1
        val-tmp1
        val-src2
        val-tmp2
        val-tmp3
        val-tmp4
        val-immi
        val-tmp5
        val-one
        val-word
        val-inc
        val-step
        val-tmp6
        val-tmp7
        ))

(define-syntax-rule (rv-verify #:name name #:init-pc pc #:fuel fuel #:microcode microcode #:solver solver #:spec spec #:assumptions assumptions)
  (begin
    (current-solver solver)
    (display (format "~a with ~a and ~a bits for ~a steps " name (current-solver) XLEN fuel))
    (flush-output)
    (when assumptions
      (assumptions test-mem))
    (define-values (m milli real-milli cpu-time)
      (time-apply (λ () (verify (let ([res (execute fuel microcode test-mem pc)])
                                  (assert (spec res))))) '()))    
    (if (eq? (unsat) (first m))
        (displayln (format "PASS ~as" (/ real-milli 1000.0)))
        (begin
          (displayln (format "FAIL ~as" (/ real-milli 1000.0))) ;; we have a model => execute procedure with the values from the model
          (displayln (first m))
          (displayln (format "Execution of ~a with the counterexample values" name))
          (define full-model (complete-solution (first m) test-mem))  ;; get a complete model, not the minimal version
          (define full-model-mem (for/list ([c test-mem])             ;; create a list (our registers) from the model
                                   (full-model c)))
          (define res (execute fuel microcode full-model-mem pc))     ;; execute the model with out starting values
          (for ([c test-mem]                                          ;; print all registers after execution stops
                [v res])
            (displayln (format "~a = ~a (~a)" c v (bitvector->natural v))))))))

(provide rv-verify val-tmp0 val-rvpc val-src1 val-tmp1 val-src2 val-tmp2 val-tmp3 val-tmp4 val-immi val-tmp5 val-one val-word val-inc val-step val-tmp6 val-tmp7)
