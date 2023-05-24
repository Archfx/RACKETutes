#lang rosette/safe

(require "spec.rkt")
(require "adder.rkt")

(define-symbolic x y (bitvector 32))

; Using Rosette verify query
(define check
  (verify
   (assert(equal? (abs-spec x y) (abs-impl x y)))))

(evaluate check)


