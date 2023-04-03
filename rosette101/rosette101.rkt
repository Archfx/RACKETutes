#lang rosette/safe 

(define (abs x)
    (if (< x 0) (- x) x))

(define-symbolic y integer?)

; Solve a constraint saying |y| = 5.
(solve
  (assert (= (abs y) 5)))

