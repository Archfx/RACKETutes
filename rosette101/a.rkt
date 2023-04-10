#lang rosette/safe

;; a.rkt
(provide f)
(define (f x)
  (display "Hello") (displayln (add1 x)))