#lang rosette/safe
#:spec "../spec/spec.rkt"
#:circuit "circuit.rkt"


(require rosutil)

; (provide R)

; (define (R spec circuit)
;   (equal? spec (get-field circuit 'adder)))



(define-symbolic x y (bitvector 32))

(define check
  (verify
   (assert(equal? spec (get-field circuit 'adder)))))
