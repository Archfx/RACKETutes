#lang rosette/safe

(require "spec.rkt")
(require "a.rkt")

(define-symbolic x (bitvector 32))

; Using Rosette verify query
(define check
  (verify
   (assert(equal? (abs-spec x) (abs-impl x)))))

(evaluate check x)