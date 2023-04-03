#lang rosette

(define (choice type)
  (define-symbolic* c type)
  c)

; A puzzle is represented as a list of 81 digits,
; obtained by concatenating the rows of the puzzle,
; from first to last. This procedure takes as input 
; a puzzle and checks that it satisfies the Sudoku rules.
(define (sudoku-check puzzle)    
  (for ([digit puzzle])             ; all digits between 1 and 9
    (assert (and (<= 1 digit) (<= digit 9))))  
  (for ([row (rows puzzle)])        ; all different in a row
    (assert (apply distinct? row)))            
  (for ([column (columns puzzle)])  ; all different in a column
    (assert (apply distinct? column)))        
  (for ([region (regions puzzle)])  ; all different in a 3x3 region
    (assert (apply distinct? region))))

(define (rows puzzle [n 9])   
  (if (null? puzzle) 
      null
      (cons (take puzzle n)
            (rows (drop puzzle n) n))))

(define (columns puzzle [n 9])
  (if (null? puzzle)
      (make-list n null)
      (map cons
           (take puzzle n)
           (columns (drop puzzle n) n))))

(define (regions puzzle)
  (define rows3 (curryr rows 3))
  (define cols3 (curryr columns 3))
  (map flatten
       (append-map
        append
        (cols3
         (append-map
          rows3
          (cols3
           (append-map rows3 (rows puzzle))))))))

(define (char->digit c)
  (- (char->integer c) (char->integer #\0)))
  
(define (string->puzzle p)
  (map char->digit (string->list p)))

(define (show puzzle)
  (pretty-print (rows puzzle)))

  
; Sample solved puzzle.
(define p0 (string->puzzle "693784512487512936125963874932651487568247391741398625319475268856129743274836159"))
; Sample unsolved puzzle where 0 represents unfilled cells.
(define p1 (string->puzzle "000000010400000000020000000000050604008000300001090000300400200050100000000807000"))

(define (puzzle->symbolic puzzle)
  (for/list ([i puzzle])
      (if (= i 0) (choice integer?) i)))

(define (solve-puzzle puzzle)
  (define sp (puzzle->symbolic puzzle))
  (define sol
    (solve (sudoku-check sp)))
  (and (sat? sol)
       (evaluate sp sol)))

(define (valid-puzzle? puzzle)
  (define sp1 (puzzle->symbolic puzzle))
  (define sp2 (puzzle->symbolic puzzle))
  (unsat?
   (solve
    (begin
      (sudoku-check sp1)
      (sudoku-check sp2)
      (assert (not (equal? sp1 sp2)))))))
      
(define (generate-puzzle)
  (for/fold ([p (solve-puzzle (make-list 81 0))])
            ([i (shuffle (build-list 81 values))])
    (let ([pi0 (list-set p i 0)])
      (if (valid-puzzle? pi0) pi0 p))))
    
  
(show p0)
(show p1)
(valid-puzzle? p0) ; #t
(valid-puzzle? p1) ; #t
(valid-puzzle? ; p1 with one more empty cell is not valid ...
 (string->puzzle
  "000000000400000000020000000000050604008000300001090000300400200050100000000807000"))

(show (solve-puzzle p0))
(show (solve-puzzle p1))

(random-seed 20190714)
(time (show (generate-puzzle)))