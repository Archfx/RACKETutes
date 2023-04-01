Racket101
====
In the previous post, we looked at setting up the environment for the tutorial series. In this post, we will be looking at basic Racket programming. At the end of the post, we will be doing some Racket programming exercises on the Jyputer environment.
Racket is a functional programming language created to avoid confusion in programming semantics. People familiar with javascript might be familiar with confusion in programming languages. Due to the mathematical nature of the syntaxes used, Racket is popular with the formal verification community. Racket comes with three components,

1. `racket` - compiler/ interpriter/ runtime
2. `DrRacket` - IDE
3. `raco` - package manager


![]({{ base_path }}/images/icons/racket.svg)

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
To get a head start, some interesting programming questions are solved in the [racket101.ipynb]()

Some useful links to get familiar with Racket

- https://www2.cs.sfu.ca/CourseCentral/383/tjd/practice-racket-sol.html
-
