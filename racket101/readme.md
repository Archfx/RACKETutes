Racket101
====
In the previous post, we looked at setting up the environment for the tutorial series. In this post, we will be looking at basic Racket programming. At the end of the post, we will be doing some Racket programming exercises on the Jyputer environment.
Racket is a functional programming language created to avoid confusion in programming semantics. People familiar with javascript might be familiar with confusion in programming languages. Due to the mathematical nature of the syntaxes used, Racket is popular with the formal verification community. Racket comes with three components,

<img align="right" width="80" height="auto" alt="" src="{{ base_path }}/images/icons/racket.svg"/>

1. `racket` - compiler/ interpriter/ runtime
2. `DrRacket` - IDE
3. `raco` - package manager


Begin with specifying the language varient 

```c
#lang racket
```

Functions
----

Racket has implementations of built-in functions for different [operations](https://docs.racket-lang.org/plait/built-ins-tutorial.html). Sample usage of built-in function `extract` given in the Racket documentation is as below.

```c
#lang racket

(define (extract str)
  (substring str 4 7))
(extract "the gal out of the city")
```

Let's save the program as "extract.rkt" and run it. 

```shell
$ racket extract.rkt
"gal"
```

Switching context from Racket.

```shell
$ racket
> (enter! "extract.rkt")
"gal"
> (extract "the boy out of the city")
"boy"
```

But in our tutorials, we will be using Racket inside the Jupyter notebook environment. Setting up the environment with ease is discussed in my [previous post]().
To get a head start, some interesting programming questions are solved in the [racket101.ipynb](https://github.com/Archfx/RACKETutes/blob/main/racket101/racket101.ipynb)

racket101.ipynb
----
Constructing the popular pascal triangle with Racket


```Racket
; Compute the factorial of a number
(define (factorial n)
    (define mult 1)
    (for ([i (in-range 1 n)]) 
        (set! mult (* i mult)))
        mult)

```


```Racket
; Construct the pascal triangle
(define (pascal n)
    (for ([i (in-range 0 n)])
        (for ([q (in-range 0 (+ (- n i) 1))])
            (display " ") )
        (for ([j (in-range 0 (+ i 1))])
            (display (/ (factorial i) (* (factorial j) (factorial (- i j))))) 
            (display " "))
            
    (displayln "" )))
```


```Racket
(pascal 5)
```

          1 
         1 1 
        1 1 1 
       1 2 2 1 
      1 3 6 3 1 


Answers to the problems from [here](https://cs.brown.edu/courses/cs019/2010/assignments/practice.html)
---

The local supermarket needs a program that can compute the value of a bag of coins. Define the program sum-coins. It consumes four numbers: the number of pennies, nickels, dimes, and quarters in the bag; it produces the amount of money in the bag.


```Racket
(define (coin_sum p n d q) (display "$")(+ (* p 0.01)  (* n 0.05) (* d 0.1) (* q 0.25)))
```


```Racket
(coin_sum 10 20 30 40)
```

    $




<code>14.1</code>



An old-style movie theater has a simple profit function. Each customer pays `$5` per ticket.
Every performance costs the theater `$20`, plus `$.50` per attendee. Develop the function 
total-profit. It consumes the number of attendees (of a show) and produces how much income 
the attendees produce.


```Racket
(define (th_profit n) (display "profit of $") (- (* n 5) 20 (* 0.5 n)))
```


```Racket
(th_profit 10)
```

    profit of $




<code>25.0</code>



Develop the function tax, which consumes the gross pay and produces the amount of tax owed.
For a gross pay of `$240` or less, the tax is 0%; for over `$240` and `$480` or less, the tax rate
is 15%; and for any pay over `$480`, the tax rate is 28%.


```Racket
(define (tax p) (display "owed tax $") 
    (if (< p 240) 0 
        (if (< p 480) (* p 0.15) (* p 0.28) )))
```


```Racket
(tax 100)
(tax 300)
(tax 500)
```

    owed tax $owed tax $owed tax $




<code>140.0</code>



Write the program discount, which takes the name of an organization that someone belongs to
and produces the discount (a percentage) that the person should receive on a purchase. 
Members of AAA get %10, members of ACM or IEEE get %15, and members of UPE get %20. 
All other organizations get no discount.


```Racket
(define (discount m) (display "Discount is ")
    (if (string=? m "AAA") (displayln "%10")
        (if (or (string=? m "ACM") (string=? m "IEEE")) (displayln "%15") 
            (if (string=? m "UPE") (displayln "%20") 0))))

```


```Racket
(discount "AAA")
(discount "ACM")
(discount "IEEE")
(discount "UPE")
```

    Discount is %10
    Discount is %15
    Discount is %15
    Discount is %20



Some useful links to get familiar with Racket
- [Documentation](https://docs.racket-lang.org/)
- [Syntaxes](https://course.ccs.neu.edu/cs5010f17/Slides/Lesson%200.4%20racket-intro.html)
- [Exercises](https://www2.cs.sfu.ca/CourseCentral/383/tjd/practice-racket-sol.html)

