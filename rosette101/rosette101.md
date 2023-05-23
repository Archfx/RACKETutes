  <picture>
  <source srcset="https://raw.githubusercontent.com/Archfx/RACKETutes/main/images/racketutes-w.svg" media="(prefers-color-scheme: dark)">
    <img src="https://raw.githubusercontent.com/Archfx/RACKETutes/main/images/racketutes.svg">
  </picture>

Rosette101
===

The previous post was about getting familiar with Racket. To make things more interesting we have used Jupyter Notebook interactive environment. This time was are going to use Rosette in the same environment.

Rosette is a solver-aided programming language that leverages the powerful [Z3](https://github.com/Z3Prover/z3) solver, alongside techniques from formal verification and symbolic execution. It provides a unique approach to programming by integrating a solver into the programming process, allowing for the exploration of program behaviors, automatic bug finding, and even program synthesis. With Rosette, developers can write programs that include symbolic values and assertions, enabling the solver to reason about program properties and detect potential issues. The solver can analyze concrete and symbolic values, identify failure-inducing inputs, and even generate repairs for faulty expressions. Additionally, Rosette supports angelic execution, where the solver searches for inputs that satisfy program requirements. By leveraging the power of solvers, Rosette empowers developers to write more reliable and robust software while automating tasks traditionally requiring manual effort and expertise in formal methods. Lets go through example use cases provided in the [Rosette documentation](https://docs.racket-lang.org/rosette-guide/index.html).

> Note: Rosette's symbolic evaluation engine operates on the program states. Instead of operating on one path at a time, it keeps track of all assumptions and assertions in the path at the beginning.  This is done through the `verification` condition (VC)`.  During the tutorial, we will be switching contexts between different examples and problems. Since we are using the same kernel to run different examples, we need to clean the VC when we switch the context.

First we start with the language definition,


```Racket
#lang iracket/lang #:require rosette/safe 
```

Symbolic Values
---

When it comes to validating designs and implementations, one thing is we can't visualize all the internal variables. These variables are sometimes constrained by different conditions. With Rosette, we can keep these variables as unknown variable variables which refers to the technical term of ```symbolic variables```. These variables are symbolically evaluated on the constraints that act on them. 

In the context of the Rosette programming language, a symbolic constant serves as a placeholder for a specific constant of the same type. When we invoke the solver, it identifies the actual value associated with a symbolic constant. Depending on the inquiries we make about a program or procedure applied to that constant, the solver informs us whether the constant "b" represents #t (true) or #f (false).

Symbolic values, including constants, can be utilized in the same manner as concrete values of the corresponding type. They can be stored in data structures or passed as arguments to procedures, enabling us to obtain other values, either concrete or symbolic, as a result.


```Racket
(define-symbolic b boolean?)
(displayln b)
```

<code>b</code>



```Racket
(displayln (boolean? b))
```

<code>#t</code>



```Racket
(displayln (integer? b))
```

<code>#f</code>



```Racket
(displayln (vector b 1))
```

<code>#(b 1)</code>



```Racket
(displayln (not b))
```

<code>(! b)</code>



```Racket
(displayln (boolean? (not b)))
```

<code>#t</code>


Assertions and Assumptions
---

Similar to other programming languages, Rosette incorporates a feature for articulating assertions, which are vital program properties that undergo verification during each execution. In Rosette, assertions function in a manner comparable to assertions in languages like Java or Racket when applied to a specific, tangible value. If the value turns out to be false, the execution abruptly halts with a runtime exception. Conversely, if the value is true, the execution continues without interruption.


```Racket
(assert #t)
(assert #f)
```

<code>[assert] failed
      context...: <br>
       /root/.local/share/racket/8.2/pkgs/rosette/rosette/base/core/exn.rkt:59:11: body of top-level</code>


Since `(assert #f)` failed, this will be available within the verification context. Therefore, we need to clear the verification conditions if they are no longer valid for the verification scenario under consideration.


```Racket
(clear-vc!)
```

In the case of a symbolic boolean value, a Rosette assertion operates differently. It does not have an immediate impact. Instead, the value is added to the ongoing verification condition (VC), and the final outcome of the assertion (pass or fail) is determined by the solver at a later stage.

Assertions serve to define properties that a program must fulfill for all valid inputs. In Rosette, as well as in other solver-aided frameworks, assumptions are employed to specify which inputs are considered valid. If a program violates an assertion when provided with valid input, the program itself is deemed at fault. However, if an assertion is violated when an invalid input is provided, the blame falls on the caller. Put simply, a program is deemed incorrect only when it violates an assertion with valid input.

Assumptions exhibit analogous behavior to assertions when applied to both concrete and symbolic values. In the case of concrete values, assuming #f results in the execution being aborted with a runtime exception, while assuming a true value is equivalent to calling (void). With symbolic values, the assumed value is accumulated within the current verification condition (VC).

Now let's see the actions of assertions with some example expressions.


```Racket
(define-symbolic i j integer?)
(assume (> j 0))     ; Add the assumption (> j 0) to the VC.
(vc-assumes (vc))
```




<code>(&lt; 0 j)</code>




```Racket
(assert (< (- i j) i))
(vc-asserts (vc))    ; The assertions must hold when the assumptions hold.

(display (vc))
```

<code>#(struct:vc (< 0 j) (|| (! (< 0 j)) (< (+ i (- j)) i)))</code>

As you can see, Rosette will generate the verification condition by combining the assumption and the assertion. `#(struct:vc (< 0 j) (|| (! (< 0 j)) (< (+ i (- j)) i)))`. Here the assumption is `(< 0 j)` and the assertion is `(|| (! (< 0 j)) (< (+ i (- j)) i))`.


```Racket
(clear-vc!)
```

Solver-Aided Queries
---

The solver focuses on reasoning about asserted properties only when we inquire about them, such as asking, "Does my program contain an execution that violates an assertion?" To facilitate these solver-aided queries, we utilize specific constructs.

Assertions can be executed on solver queries (z3). As an example, we define the function below utilizing two different methods. The first one defines the polynomial and the second one defines the factorized polynomial. We can assert the function for equivalence using Rosette in the following manner.


```Racket
(define (poly x)
 (+ (* x x x x) (* 6 x x x) (* 11 x x) (* 6 x)))
 
(define (factored x)
 (* x (+ x 1) (+ x 2) (+ x 2)))
 
(define (same p f x)
 (assert (= (p x) (f x))))
```


```Racket
(same poly factored 0)
(same poly factored -1)
(same poly factored -2)
```

Now let's try this with another different function, to check whether the assertion will fail.


```Racket
(define (factored-2 x)
 (* x (+ x 3) (+ x 2) (+ x 2)))
```


```Racket
(same poly factored-2 0)
(same poly factored-2 -1)
(same poly factored-2 -2)
```

<code>[assert] failed
      context...:<br>
       /root/.local/share/racket/8.2/pkgs/rosette/rosette/base/core/exn.rkt:59:11: body of top-level
       eval:7:0: same
       /usr/share/racket/pkgs/sandbox-lib/racket/sandbox.rkt:703:9: loop</code>


As expected assertion fails. Remember we need to clear the `vc` to avoid confusion later.


```Racket
(clear-vc!)
```

Verification
---

Program verification solves the problem of verifying the program for all the legal inputs. The brute-force approach would be to iterate through all the values one by one. Although this sounds promising at capturing any bug if exists, in the case of a 32-bit adder circuit, input space would be $2^{64}$ which is a large number.
Instead of going through the brute-force path, Rosette delegates this task to `Z3 constraint solver` with the help of `verify` query. If some input violates the behavior solver will return it as a counterexample.



```Racket
(define-symbolic i integer?)
(define cex (verify (same poly factored i)))
```

This will create a solver query for the Z3 solver with relevant expressions. Rosette will direct the output from Z3 back into the Jupyter environemt. Now let's see this in action.


```Racket
(evaluate i cex)
```




<code>14</code>



As the result suggest, we have a counterexample for the `cex` function. We can substitute the counterexample value to see the results of two functions.


```Racket
(poly 14)
```




<code>57120</code>




```Racket
(factored 14)
```




<code>53760</code>




```Racket
(same poly factored 14)
```

<code>[assert] failed
      context...:<br>
       /root/.local/share/racket/8.2/pkgs/rosette/rosette/base/core/exn.rkt:59:11: body of top-level
       eval:7:0: same</code>



```Racket
(clear-vc!)
```


Synthesis
----

The solver possesses the capability to not only identify inputs that cause failures and pinpoint faults but also synthesize repairs for faulty expressions. To initiate the repair process, we begin by substituting each faulty expression with a syntactic placeholder called a "hole." A program containing these holes is referred to as a sketch. The solver then completes the sketch by filling the holes with expressions in a manner that ensures all assertions in the resulting program pass for all inputs.

The following code snippet demonstrates the sketch for our flawed factored procedure. We created this sketch by replacing the constants in the minimal core with (??) holes, which are subsequently filled with numerical constants.


```Racket
#lang iracket/lang #:require rosette/safe
```


```Racket
(require rosette/safe)
(require rosette/lib/synthax)

(define (poly x)
 (+ (* x x x x) (* 6 x x x) (* 11 x x) (* 6 x)))
 
(define (factored x)
 (* x (+ x (??)) (+ x (??)) (+ x (??))))
 
(define (same p f x)
 (assert (= (p x) (f x))))

```

The (??) construct is imported from the rosette/lib/synthax library, which not only offers the (??) construct for specifying simple holes but also provides additional constructs for defining more intricate holes. For instance, you have the ability to specify a hole that is filled with an expression randomly chosen from a grammar that you define.

Following query will complete the sketch by filling (??) with appropriate values.


```Racket
(define-symbolic i integer?)
(define binding
    (synthesize #:forall (list i)
                #:guarantee (same poly factored i)))
;(print-forms binding)
(displayln binding)
```

<code>(model
[??:eval:8:12 1]<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [??:eval:8:23 2]<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;[??:eval:8:34 3])</code>



```Racket
(clear-vc!)
```

Note that we can't use `print-forms` within Jupyter Notebook since we can save the program directly to Disc. Instead, we print the model and it will show the solution for three holes (??) that we have created.

Angelic Execution
----

In addition to verification and repair, Rosette also supports another solver-aided query known as "angelic execution." This query operates in the opposite direction of verification. When given a program containing symbolic values, angelic execution instructs the solver to discover a binding for those values that enables the program to execute successfully, meaning it does not encounter any assertion failures.

Angelic execution can be employed for various purposes such as solving puzzles, running incomplete code, or "inverting" a program by searching for inputs that produce a desired output. For instance, we can utilize the solver to find two distinct input values, which are not zeros of the poly function, yet result in the same output when processed by poly.


```Racket
(define-symbolic x y integer?)
(define sol
    (solve (begin (assert (not (= x y)))
                  (assert (< (abs x) 10))
                  (assert (< (abs y) 10))
                  (assert (not (= (poly x) 0)))
                  (assert (= (poly x) (poly y))))))
```


```Racket
evaluate x sol
```




<code>(model
 [x -4]
 [y 1])</code>




```Racket
(evaluate y sol)
```




<code>1</code>




```Racket
(evaluate (poly x) sol)
```




<code>24</code>




```Racket
(evaluate (poly y) sol)
```




<code>24</code>




```Racket
(clear-vc!)
```

### Examples


Finding an integer whose absolute value is X with Racket


```Racket
#lang iracket/lang #:require rosette/safe 

(define (abs x)
    (if (< x 0) (- x) x))
```


```Racket
; define a symbolic variable y
(define-symbolic y integer?)
; Solve a constraint saying |y| = 5.
(solve
  (assert (= (abs y) 5)))
```




<code>(model
 [y -5])</code>




```Racket
(clear-vc!)

```

### Absolute Value Find Implementation

This problem is from CAV 2019 tutorial session which was conducted by [Emina](https://github.com/emina).
Suppose that you are an app developer for a super low-power chip that achieves peak energy efficiency on programs with few or no branches. To build apps faster, you hire Ben Bitdiddle to create a library of efficient primitives for this chip, starting with a branch-free function that computes the absolute value of a 32-bit bitvector. 


```Racket
#lang iracket/lang #:require rosette
```


```Racket
(define (abs-spec x)
  (if (bvslt x (bv 0 32))
      (bvneg x)
      x))
```

Ben comes up with the following implementation that works on his test suite:


```Racket
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
```

Help review Ben’s code by answering the following questions. If a question requires you to modify his implementation in any way, do so on a fresh copy with a new name such as abs-impl-N where N is the question number.

Does Ben’s implementation work on all 32-bit inputs? Use the verify query to check.


```Racket
; Let's define a generic 32bit vector
(define-symbolic x (bitvector 32))

; Using Rosette verify query
(define check
  (verify
   (assert(equal? (abs-spec x) (abs-impl x)))))

(evaluate check x)
```




<code>(model
 [x (bv #x8404c7c0 32)])</code>



Apparently, we have a counter-example where implementation does not satisfy the specification.

The verifier will reveal that Ben’s implementation is buggy. Use debug to localize the fault found by the verifier (and remember to save your work to a file before invoking debug).

Use synthesize to fix Ben’s implementation as suggested by the debugger. You can assume that if Ben has made an error, it is always of the same kind: using an arithmetic operator (such as addition or subtraction) instead of a bitwise operator that takes the same arguments. It is easiest to sketch this knowledge using the choose construct.


```Racket
(require rosette/lib/synthax)

(define (abs-impl-3 x) 
  (let* ([o1 (bvashr x (bv 31 32))]
         [o2 ((choose bvadd bvand bvor bvxor bvshl bvlshr bvashr) x o1)]
         [o3 ((choose bvsub bvand bvor bvxor bvshl bvlshr bvashr) o2 o1)])
    o3))

```


```Racket
(synthesize
  #:forall x
  #:guarantee (assert (equal? (abs-spec x) (abs-impl-3 x))))
```




<code>(model
[0$choose:eval:5:15 #t]<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[1$choose:eval:5:15 #f]<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[2$choose:eval:5:15 #f]<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[3$choose:eval:5:15 #f]<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[4$choose:eval:5:15 #f]<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[5$choose:eval:5:15 #f]<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[0$choose:eval:6:15 #f]<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[1$choose:eval:6:15 #f]<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[2$choose:eval:6:15 #f]<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[3$choose:eval:6:15 #t])</code>



In conclusion, the Rosette tutorial has provided a comprehensive introduction to the powerful features and capabilities of this solver-aided programming language. Through its integration with the Z3 solver and the utilization of formal verification and symbolic execution techniques, Rosette empowers developers to write more reliable and robust software. By incorporating symbolic values, assertions, and the ability to reason about program properties, Rosette enables the automatic detection of bugs, generation of program repairs, and even angelic execution to find inputs that meet specific requirements. The tutorial has equipped programmers with the knowledge and tools to leverage Rosette's unique approach, unlocking new possibilities for software development and verification. With Rosette, developers can enhance their programming workflows, improve code quality, and tackle complex problems more effectively. As they continue to explore and apply the concepts and techniques covered in the tutorial, developers can confidently embrace the potential of Rosette to build innovative and dependable software solutions.
