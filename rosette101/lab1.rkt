#lang rosette

#|Suppose that you are an app developer for a super low-power chip that achieves peak energy efficiency on programs with few or no branches. To build apps faster, you hire Ben Bitdiddle to create a library of efficient primitives for this chip, starting with a branch-free function that computes the absolute value of a 32-bit bitvector. Here is a reference implementation (specification) for this function in Rosette, using the built-in bitvector datatype:|#

(define (abs-spec x)
  (if (bvslt x (bv 0 32))
      (bvneg x)
      x))

(define (abs-impl x) 
  (let* ([o1 (bvashr x (bv 31 32))]
         [o2 (bvadd x o1)]
         [o3 (bvsub o2 o1)])
    o3))

; zero, positive, negative ...
(assert (equal? (abs-impl (bv #x00000000 32)) 
                  (abs-spec (bv #x00000000 32))))
(assert (equal? (abs-impl (bv #x00000003 32)) 
                  (abs-spec (bv #x00000003 32))))
(assert (equal? (abs-impl (bv #x80000000 32)) 
                  (abs-spec (bv #x80000000 32))))

;Does Ben’s implementation work on all 32-bit inputs? Use the verify query to check.

(define-symbolic x (bitvector 32))

(define cex
  (verify
   (assert
    (equal? (abs-spec x) (abs-impl x)))))

(define fault (evaluate x cex))

fault


; (require rosette/query/debug rosette/lib/render)

; (define/debug (abs-impl-2 x) 
;   (let* ([o1 (bvashr x (bv 31 32))]
;          [o2 (bvadd x o1)]
;          [o3 (bvsub o2 o1)])
;     o3))


; (render
;  (debug [(bitvector 32)]
;         (assert (equal? (abs-spec fault) (abs-impl-2 fault)))))

(require rosette/lib/synthax)

(define (abs-impl-3 x) 
  (let* ([o1 (bvashr x (bv 31 32))]
         [o2 ((choose bvadd bvand bvor bvxor bvshl bvlshr bvashr) x o1)]
         [o3 ((choose bvsub bvand bvor bvxor bvshl bvlshr bvashr) o2 o1)])
    o3))

(print-forms
 (synthesize
  #:forall x
  #:guarantee (assert (equal? (abs-spec x) (abs-impl-3 x)))))