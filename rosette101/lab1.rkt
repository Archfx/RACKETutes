#lang rosette

; https://en.wikipedia.org/wiki/Boyer–Moore_majority_vote_algorithm

; Boyer-Moore majority voting algorithm.
(define (boyer-moore xs)
  (define m (car xs))
  (define i 0)
  (for ([x xs])
    (cond [(= i 0)
           (set! m x)
           (set! i 1)]
          [(= m x)
           (set! i (+ i 1))]
          [else
           (set! i (- i 1))]))
  m)

; Check the algorithm for a list of n arbitrary integers.
(define (check n [bw #f])
  (current-bitwidth bw)
  (define-symbolic* xs integer? [n])
  (define-symbolic* m integer?)
  (verify
   #:assume ; there is a majority value ...
   (assert (> (count (curry = m) xs)
              (quotient n 2)))
   #:guarantee ; algorithm works
   (assert (= m (boyer-moore xs)))))

(time (check 10)) 


; Check the algorithm for a list of n arbitrary integers.
(define (check2 n [bw #f])
  (current-bitwidth bw)
  (define-symbolic* xs integer? [n])
  (define-symbolic* m integer?)
  (verify
   (when ; there is a majority value ...
       (> (count (curry = m) xs)
          (quotient n 2))
     (assert (= m (boyer-moore xs)))))) ; algorithm works

(time (check2 10)) 