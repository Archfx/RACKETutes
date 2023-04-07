#lang rosette/safe
(require racket)
(require racket/vector)

(define (add-vectors a b)
  (define (full-adder x y c-in)
    (let* ((sum (bitwise-xor x y c-in))
           (carry (bitwise-ior (bitwise-and x y) (bitwise-and c-in (bitwise-xor x y)))))
      (cons sum carry)))
  (let* ((result (make-vector 32 0))
         (carry 0))
    (for ([i (in-range 31 -1 -1)])
      (let* ((full-add (full-adder (vector-ref a i) (vector-ref b i) carry))
             (sum (car full-add))
             (carry (cdr full-add)))
        (vector-set! result i sum)))
    result))

(define (add-vectors2 vec1 vec2)
  (define result (make-vector 32 0))
  (define carry 0)
  (let loop ((i 31))
    (cond
      ((< i 0) result)
      (else
       (let ((sum (+ (vector-ref vec1 i) (vector-ref vec2 i) carry)))
         (vector-set! result i (bitwise-and sum #xffffffff))
         (set! carry (if (< sum #x100000000) 0 1))
         (loop (- i 1)))))))

; (define-symbolic a b (bitvector 32))
; (define-symbolic b (bitvector 32))

; (assert (equal? (add-vectors #(0 1 0 0 1 1 0 1 0 0 0 1 1 1 0 1 1 1 0 1 0 0 0 0 1 1 1 1 0 1 1 1) #(0 1 0 0 1 1 0 1 0 0 0 1 1 1 0 1 1 1 0 1 0 0 0 0 1 1 1 1 0 1 1 1)) 
                ;   (add-vectors2 #(0 1 0 0 1 1 0 1 0 0 0 1 1 1 0 1 1 1 0 1 0 0 0 0 1 1 1 1 0 1 1 1) #(0 1 0 0 1 1 0 1 0 0 0 1 1 1 0 1 1 1 0 1 0 0 0 0 1 1 1 1 0 1 1 1))))

(define a (make-vector 32 'symbolic-value))
(define b (make-vector 32 'symbolic-value))
; Using Rosette verify query
 (define (check x y)
  (verify
   (assert(equal? (add-vectors a b) (add-vectors2 a b)))))

;    (assert(equal? (add-vectors a b) (add-vectors2 a b)))

; (sat? (check a b))
(check a b)
(evaluate check (list a b))