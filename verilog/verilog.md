  <picture>
  <source srcset="https://raw.githubusercontent.com/Archfx/RACKETutes/main/images/racketutes-w.svg" media="(prefers-color-scheme: dark)">
    <img src="https://raw.githubusercontent.com/Archfx/RACKETutes/main/images/racketutes.svg">
  </picture>

Veri(fy)log : Verifying Hardware with Rosette
===

In previous posts, we discussed Racket and Rosette. This is the post where we are going to verify our hardware designs using the infrastructure we have developed so far. In a nutshell, we will be looking at verifying Verilog hardware designs with Rosette.



First, we will be looking at `bitvectors` data type in Rosette. Then, we will use a Verilog implemented adder circuit to demonstrate how we can use Rosette for hardware verification. We need to follow several steps to convert Verilog designs to Racket (.rkt) native formats. For this purpose, we need [Yosys](https://yosyshq.readthedocs.io/) and [rtlv](https://github.com/anishathalye/rtlv).

### Bitvectors

In Rosette, the bitvector data type represents a fixed-size sequence of binary digits, commonly known as bits. It is used to model and manipulate binary data at a low level, allowing precise control over the individual bits. Bitvectors in Rosette are defined with a specific width, determining the number of bits they can hold. The bitvector data type in Rosette supports various operations, including bitwise logical operations (AND, OR, XOR, NOT), arithmetic operations (addition, subtraction, multiplication), shifts (left shift, right shift), comparisons (equality, less than, greater than), as well as extraction and concatenation of bits. Bitvectors are especially useful for tasks such as low-level programming, cryptographic operations, hardware design, and other scenarios where precise bit-level manipulation is required. By providing native support for bitvectors, Rosette enables developers to work with binary data more efficiently and accurately within their programs.

Rosette defines the following operation types, which might be come in handy for hardware verification

- Comparison Operators (`bveq`,`bvstl`,`bvult`, ...)
- Bitwise Operators (`bvnot`, `bvand`, `bvor`, ...)
- Arithmetic Operators (`bvadd`, `bvsub`, `bvmul`, ...)
- Conversion Operators (`concat`, `extract`, ...)
- Additional Operators (`bit`, `bvzero`, ...)

You can find more information about bitvector data type from [here](https://docs.racket-lang.org/rosette-guide/sec_bitvectors.html)

### Verilog to SMT (.v -> .smt2)

Now that all the background is set, let's get into hardware verification. First, we will convert the hardware design into a formal model (which in this case it is going to be a smt2 model)  so that our underlying Z3 solver can understand the implementation. For this purpose we use [Yosys](). Let's look at a simple Verilog implementation of a 32-bit adder.

```verilog
module adder (
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);
assign c = a + b;
endmodule
```

In order to convert this into smt2 format we can use the following command

```shell
yosys -p 'read_verilog -defer adder.v' -p 'prep -flatten -top adder -nordff' -p 'write_smt2 -stdt adder.smt2'
```

You can generate the command similar commands for Yosys to convert hardware implementations in to different formats from [here](https://archfx.github.io/cad.html). 

### SMT to Racket (.smt2 -> .rkt)
This will generate the smt2 transformed verilog implementation. We need to add the language definition from the `rtlv` to identify it via Rosette. For that, we can use the following command.

```shell
echo #lang yosys $ cat adder.smt > adder.rkt
```

This will generate the `adder.rkt` file which we will be used to refer to the implementation.


### Import the Design

In order to import the hardware circuit into the rosette framework we use the `rtlv` library. We use the `require` construct with the following set of racket packages. Note that when specifying the path for the converted racket file of the implementation, you have the path relative to the place you launched the Jupyter Notebook.


```racket
#lang iracket/lang #:require rosette/safe 
```


```racket
(require rackunit
         "verilog/adder/adder.rkt"
         rosutil
         yosys
         (only-in racket/base string-append parameterize regexp-match))
```

### Specification

Let's write a simple specification for the adder circuit that we have implemented in verilog. For defining the functionality, we will be using bitvector data type. The specification can be simple as below.


```racket
;spec
(define (adder-spec x y)
   display (bvadd x y))
```

### Test Cases
Racket has an inbuilt struct called `test-case` which will be evaluated as a unit test. We can check our implementation against the specification by giving it some inputs and checking for output consistency with the `test-case` syntax as below.


```racket
(test-case "eq1"
  (define s0 (update-adder_s
              (new-symbolic-adder_s)
              [a (bv 4 32)]
              [b (bv 5 32)]))
    (assert (check-equal? (|adder_n c| s0) (adder-spec (bv 4 32) (bv 5 32)))))
```


```racket
(test-case "eq2"
  (define s0 (update-adder_s
              (new-symbolic-adder_s)
              [a (bv 143 32)]
              [b (bv 243 32)]))
    (assert (check-equal? (|adder_n c| s0) (adder-spec (bv 143 32) (bv 243 32)))))
```

### Verification
For the verification, we can write a wrapper around the implementation mapping the corresponding inputs and outputs between the implementation and formal model.


```racket
(define (adder-imp x y)
  (define s0 (update-adder_s
              (new-symbolic-adder_s)
              [a x]
              [b y]))
    (|adder_n c| s0))
```

Then we can create a function to ask for the equivalence checking as below,


```racket
(define (equivalence imp spec x y)
 (assert (equal? (imp x y) (spec x y) )))

```


```racket
(define-symbolic x (bitvector 32))
(define-symbolic y (bitvector 32))


(define satcheck (verify (equivalence adder-imp adder-spec x y)))
```


```racket
satcheck
```




<code>(unsat)</code>



`verify` query returns with `unsat` status, which basically means it does not find a counterexample to violate the assertion. Let's try to change the specification such that the assertion will fail.


```racket
;notspec
(define (adder-not-spec x y)
   display (bvsub x y)) 
```


```racket
(define satchecknot (verify (equivalence adder-imp adder-not-spec x y)))
```


```racket
satchecknot
```




<code>(model
 [x (bv #x00000000 32)]
 [y (bv #x20000000 32)])</code>




```racket
(evaluate (list x y) satchecknot)
```




<code>(list (bv #x00000000 32) (bv #x20000000 32))</code>




```racket
(clear-vc!)
```

As you can see, Rosette will produce a counterexample to show that `adder-not-spec` is not consistent with `adder-imp`.

In this tutorial, we looked at a simple hardware design verification procedure. Once the hardware is lifted into racket syntax by rtlv, all rosette verification constructs can be used to verify the implementations. Rosette + rtlv offers a powerful and effective solution for hardware verification. By leveraging solver-aided techniques and integrating with the Z3 solver, this combination enables engineers and designers to validate and verify hardware designs with confidence. Rosette's support for symbolic bitvectors, constraints, and logical operations allows for precise modeling and manipulation of hardware components at the bit level. This capability is particularly valuable in the context of hardware verification, where complex interactions and intricate behaviors need to be thoroughly examined. With Rosette, engineers can express and reason about hardware properties, perform extensive testing, and automatically generate inputs that satisfy desired conditions. By employing Rosette for hardware verification, professionals can significantly enhance the reliability, correctness, and quality of their hardware designs, reducing the risk of errors and ensuring optimal performance.
