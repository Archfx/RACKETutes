Rosette101
=====

The previous post was about getting familiar with Racket. To make things more interesting we have used Jupyter notebook interactive environment. This time was are going to use Rosette in the same environment.

Rosette is a solver-aided programming language. To be specific popular [Z3](https://github.com/Z3Prover/z3) is behind the curtains of Rosette. With the power of Z3, Rosette programs can understand and handle symbolic values, assertions, assumptions, and queries. Which is a vital part of verifying firmware and hardware designs.

Get Set
---

When it comes to validating designs and implementations, one thing is we can't visualize all the internal variables. These variables are sometimes constrained by different conditions. With Rosette, we can keep these variables as unknown variable variables which refers to the technical term of ```symbolic variables```. These variables are symbolically evaluated on the constraints that act on them. 



Assertions and Assumptions
---





Verification
---

Program verification solves the problem of verifying the program for all the legal inputs. The brute force approach would be to iterate through all the values one by one. Although this sounds promising at capturing any bug if exists, in the case of a 32-bit adder circuit, input space would be $2^64$ which is a large number.
Instead of going through the brute force path, Rosette delegates this task to `z3 constraint solver` with the help of `verify` query.


Synthesis
----




Rosette Exercises
----

- [beginner](https://homes.cs.washington.edu/~emina/media/cav19-tutorial/lab1.html)