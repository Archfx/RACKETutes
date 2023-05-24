#lang rosette/safe

;; a.rkt
(provide f)
(define (f x)
  (displayln (add1 x)))