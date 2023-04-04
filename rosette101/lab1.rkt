; ; #lang rosette
; ; (require rosette/lib/synthax)
 
; ; (define (poly x)
; ;  (+ (* x x x x) (* 6 x x x) (* 11 x x) (* 6 x)))
 
; ; (define (factored x)
; ;  (* (+ x (??)) (+ x 1) (+ x (??)) (+ x (??))))
 
; ; (define (same p f x)
; ;  (assert (= (p x) (f x))))
; #lang racket/base

; (define (add-32-cla a b)
;   (define (generate-generate-carry bit-list)
;     (let loop ((bit-list bit-list)
;                (p 0)
;                (g 0)
;                (carry-list '()))
;       (cond ((null? bit-list) (reverse carry-list))
;             (else
;              (let* ((a (car bit-list))
;                     (b (cadr bit-list))
;                     (p1 (bitwise-and a b))
;                     (p2 (bitwise-and a p))
;                     (p3 (bitwise-and b p))
;                     (p4 (bitwise-and p1 p))
;                     (g1 (bitwise-xor a b))
;                     (g2 (bitwise-xor p g)))
;                (loop (cdr bit-list) p4 g2 (cons (bitwise-ior p1 p2 p3) carry-list)))))))
  
;   (define carry-in 0)
;   (define carry-list (generate-generate-carry (map bitwise-xor a b)))
;   (define sum-list (reverse (generate-generate-carry (map bitwise-xor carry-list (append a b (make-list 32 0))))))

;   (apply + (map (lambda (bit i) (bitwise-arithmetic-shift bit i)) sum-list (range 0 32 1))))



; ;  (add-32-cla (vector 0 1 0 1 0 1 0 1
; ;                                  0 1 0 1 0 1 0 1
; ;                                  0 1 0 1 0 1 0 1
; ;                                  0 1 0 1 0 1 0 1)
; ;                               (vector 1 0 1 0 1 0 1 0
; ;                                  1 0 1 0 1 0 1 0
; ;                                  1 0 1 0 1 0 1 0
; ;                                  1 0 1 0 1 0 1 0))
#lang racket/base

(require 2htdp/image)

(define (main)
  (define WIDTH 400)
  (define HEIGHT 400)

  (define img (empty-scene WIDTH HEIGHT))

  (define line-shape (line 50 50 250 250 "red"))

  (place-image line-shape (/ WIDTH 2) (/ HEIGHT 2) img)

  (define filename "line.png")
  (define output-bitmap (bitmap filename))
  (save-image output-bitmap img 'png)

  (system (format "open ~a" filename)))