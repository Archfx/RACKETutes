## Verification of Systems Code

Previously we looked at the verification of Verilog hardware implementations. In this post, we will be looking at the verification of firmware or systems code. Here the hardware implementation is abstracted with Instruction Level Abstraction (ILA). This allows us to make complex verification problems more tractable.

ILAS refers to a level of abstraction in computer systems design and analysis that focuses on the behavior and functionality of individual instructions within a processor or microarchitecture. It involves representing and reasoning about instructions as fundamental units of computation, abstracting away lower-level details and complexities. At the instruction level, the emphasis is on understanding the functionality and effects of instructions, including their operation, data flow, dependencies, and control flow. ILA provides a higher-level perspective that allows for the analysis of programs and systems without getting into the intricacies of the underlying hardware implementation.

## Setup

We will be using the same environment with Jupyter Notebook with the Racket extension called Serval. You can use the same steps that we discussed in the [initial post](https://archfx.github.io/posts/2023/04/racketutes1/) of this series for the configuration but with the following docker container.

```shell
docker pull archfx/serval
```
<p align="center"><a href="https://hub.docker.com/r/archfx/serval"><img src="https://dockerico.blankenship.io/image/archfx/serval"/></a></p>

otherthan that every step for the environment stays the same as the [previous setup](https://archfx.github.io/posts/2023/04/racketutes1/). In addition to Racket, Rosette, Z3 and Serval this container consists of RISC-V tool-chain components which will allow us to compile and verify RISC-V systems code which we will look in future post.

This post as a Jupyter Notebook is available [here]().


## Serval

As I mentioned earlier, Serval is a Racket extension built with Rosette that can act as a processor interpreter. We can define the ILA for the processor that your firmware is built for, with Serval. Then, we can compile the firmware, obtain the binary and using Serval we can uplift the systems code into Racket supporting syntaxes. There are few things to note here, Serval does not support concurrent codes and codes with unbounded loops. I don't think these are limitations, since as verification engineers, we need to be creative to solve these kinds of issues.

### ToyRISC Example

Serval provides an example interpreter and state-machine refinement with safety property verification for a sample processor which is based on a sample instruction set called ToyRISC. We will be looking at each of the components of this example. Finally, we will make some modifications to the code, such that it violates the expected behavior.

First, we start by importing `rosette` ,


```racket
#lang iracket/lang #:require rosette
```

Then we need to import the serval definitions,


```racket
; import serval functions with prefix "serval:"
(require
  serval/lib/unittest
  rackunit/text-ui
  (prefix-in serval:
    (combine-in serval/lib/core
                serval/spec/refinement
                serval/spec/ni)))

```

## Interpriter

An interpreter is a computer program or software component that reads and executes code or instructions directly without the need for prior compilation. It takes source code written in a high-level programming language and translates it into machine code or performs the instructions directly on the fly. Interpreters work line by line, executing statements in a sequential manner.

### ToyRISC Interpreter

The interpreter defines the operations available in the instruction set. This is similar to an implementation of an instruction set simulator. In the case of the ToyRISC example, the instruction set only contains 5 instructions of `ret`,`bnez`,`sgtz`,`sltz` and `li`. Basically, the interpreter will interpret the binary of the firmware for Rosette for formal proofs.


```racket
#| ToyRISC Interpreter |#

; cpu state: program counter and integer registers
(struct cpu (pc regs) #:mutable #:transparent)

; interpret a program from a given cpu state
(define (interpret c program)
  ; Use Serval's "split-pc" symbolic optimization
  (serval:split-pc (cpu pc) c
    ; fetch an instruction to execute
    (define insn (fetch c program))
    ; decode an instruction into (opcode, rd, rs, imm)
    (match insn
      [(list opcode rd rs imm)
          ; execute the instruction
          (execute c opcode rd rs imm)
          ; recursively interpret a program until "ret"
          (when (not (equal? opcode 'ret))
            (interpret c program))])))

; fetch an instruction based on the current pc
(define (fetch c program)
  (define pc (cpu-pc c))
  ; the behavior is undefined if pc is out-of-bounds
  (serval:bug-on (< pc 0))
  (serval:bug-on (>= pc (vector-length program)))
  ; return the instruction at program[pc]
  (vector-ref program pc))

; shortcut for getting the value of register rs
(define (cpu-reg c rs)
  (vector-ref (cpu-regs c) rs))

; shortcut for setting register rd to value v
(define (set-cpu-reg! c rd v)
  (vector-set! (cpu-regs c) rd v))

; execute one instruction
(define (execute c opcode rd rs imm)
  (define pc (cpu-pc c))
  (case opcode
    [(ret)  ; return
       (set-cpu-pc! c 0)]
    [(bnez) ; branch to imm if rs is nonzero
       (if (! (= (cpu-reg c rs) 0))
           (set-cpu-pc! c imm)
           (set-cpu-pc! c (+ 1 pc)))]
    [(sgtz) ; set rd to 1 if rs > 0, 0 otherwise
       (set-cpu-pc! c (+ 1 pc))
       (if (> (cpu-reg c rs) 0)
         (set-cpu-reg! c rd 1)
         (set-cpu-reg! c rd 0))]
    [(sltz) ; set rd to 1 if rs < 0, 0 otherwise
       (set-cpu-pc! c (+ 1 pc))
       (if (< (cpu-reg c rs) 0)
         (set-cpu-reg! c rd 1)
         (set-cpu-reg! c rd 0))]
    [(li)   ; load imm into rd
       (set-cpu-pc! c (+ 1 pc))
       (set-cpu-reg! c rd imm)]))
```

## Application Code

This is the systems code, that we need to perform the verification. This can be implemented in a high-level language such as `c` and can be compiled using the `gcc` compiler corresponding to the instruction set architecture of the system. Then from the binary, instructions should be extracted. Disassembled code is used as the implementation of the systems code for the verification process. 


### Example Application
An example application code implementation, for the ToyRISC example instruction set is as below,


```racket
#|
  Sign implementation
|#

#|
0: sltz a1, a0   ; a1 <- if (a0 < 0) then 1 else 0
1: bnez a1, 4    ; branch to 4 if a1 is nonzero
2: sgtz a0, a0   ; a0 <- if (a0 > 0) then 1 else 0
3: ret           ; return
4: li   a0, -1   ; a0 <- -1
5: ret           ; return
|#

(define sign-implementation #(
 (sltz 1 0 #f)
 (bnez #f 1 4)
 (sgtz 0 0 #f)
 (ret #f #f #f)
 (li 0 #f -1)
 (ret #f #f #f)
))
```

## Specification

Finally, we need to have the specification for the imeplementation where we evaluate the consistency of the implementation. We write the specification in Racket syntax with Serval-defined constructs.

### Example Specification

The example specification for the application code is defined below. In addition to the functional specification, there are definitions related to the safety properties of the specification.


```racket
#|
  Sign specification
|#

; Note that we mark the struct as mutable and transparent
; for better debugging and interoperability with Serval libraries
(struct state (a0 a1) #:mutable #:transparent) ; specification state

; functional specification for the sign code
(define (spec-sign s)
  (define a0 (state-a0 s))
  (define sign (cond
    [(positive? a0)  1]
    [(negative? a0) -1]
    [else            0]))
  (define scratch (if (negative? a0) 1 0))
  (state sign scratch))

; abstraction function: impl. cpu state to spec. state
(define (AF c)
  (state (cpu-reg c 0) (cpu-reg c 1)))

; Mutable version of sign specification
(define (spec-sign-update s)
  (let ([s2 (spec-sign s)])
    (set-state-a0! s (state-a0 s2))
    (set-state-a1! s (state-a1 s2))))
```

## State-machine refinement

State machine refinement is the systematic process of transforming an abstract or high-level specification of a system into a more detailed and concrete representation while preserving the intended behavior and properties. It involves incrementally adding more specific details to the states, transitions, and actions of a state machine, ensuring consistency with the abstract specification and enabling stepwise development, formal analysis, and verification of complex systems.

### Example State-machine refinement

State-machine refinement is evaluated symbolically. Serval defines the `serval:verify-refinement` construct to feed corresponding components such as implementation, specification, etc into the verification problem. Example state-machine refinement for the implementation is given below,


```racket
#| State-machine refinement |#

; Fresh implementation state
(define-symbolic X Y integer?)
(define c (cpu 0 (vector X Y)))

; Fresh specification state
(define-symbolic a0 a1 integer?)
(define s (state a0 a1))

; Counterexample handler for debugging
(define (handle-counterexample sol)
  (printf "Verification failed:\n")
  (printf "Initial implementation state: ~a\n" (evaluate (cpu 0 (vector X Y)) sol))
  (printf "Initial specification state: ~a\n" (evaluate (state a0 a1) sol))
  (printf "Final implementation state ~a\n" (evaluate c sol))
  (printf "Final specification state ~a\n" (evaluate s sol)))

; Verify refinement
(define (verify-refinement)
  (serval:verify-refinement
  #:implstate c
  #:impl (λ (c) (interpret c sign-implementation))
  #:specstate s
  #:spec spec-sign-update
  #:abs AF
  #:ri (const #t)
  null
  handle-counterexample))
```

## Safety properties

Safety properties in formal verification refer to specifications that assert the absence of specific undesirable behaviors or violations within a system. These properties focus on preventing or ruling out certain scenarios or errors, ensuring that the system does not reach states or exhibit behaviors that could lead to safety hazards or incorrect outcomes. By expressing safety properties using formal languages like temporal logic, formal verification techniques can rigorously analyze and verify that the system satisfies these properties, providing assurance that critical safety requirements are met and potential vulnerabilities or risks are identified and mitigated.

### Example Safety property

Serval defines the `serval:check-step-consistency` construct to feed state-related data, which will be used for the safety property verification. Example safety property for the implementation is given below,



```racket
#| Safety property |#

(define (~ s1 s2)
  (equal? (state-a0 s1) (state-a0 s2))) ; filter out a1

(define (verify-safety)
  (serval:check-step-consistency
    #:state-init (λ () (define-symbolic* X Y integer?) (state X Y))
    #:state-copy (λ (s) (struct-copy state s))
    #:unwinding ~
    spec-sign-update))

```

## Verification

Finally, we execute the verification process by invoking the Racket unit testing constructs with state machine refinement and safety properties.


```racket
(run-tests (test-suite+ "ToyRISC tests"
  (test-case+ "ToyRISC Refinement" (verify-refinement))
  (test-case+ "ToyRISC Safety" (verify-safety))))
```

    ToyRISC tests
    [ RUN      ] "ToyRISC Refinement"
    [       OK ] "ToyRISC Refinement" (96ms cpu) (806ms real) (37 terms)
    [ RUN      ] "ToyRISC Safety"
    [       OK ] "ToyRISC Safety" (28ms cpu) (694ms real) (27 terms)
    2 success(es) 0 failure(s) 0 error(s) 2 test(s) run





<code>0</code>



Let's modify the implementation a bit to introduce an error to observe the behavior in a situation where implementation does not satisfy the implementation.


```racket
(define not-sign-implementation #(
 (sltz 1 0 #f)
 (bnez #f 1 4)
 (sgtz 0 0 #f)
 (ret #f #f #f)
 (li 0 #f -2)
 (ret #f #f #f)
))
```


```racket
(define (fail-verify-refinement)
  (serval:verify-refinement
  #:implstate c
  #:impl (λ (c) (interpret c not-sign-implementation))
  #:specstate s
  #:spec spec-sign-update
  #:abs AF
  #:ri (const #t)
  null
  handle-counterexample))
```


```racket
(run-tests (test-suite+ "ToyRISC tests"
  (test-case+ "ToyRISC Refinement" (fail-verify-refinement))))
```

    ToyRISC tests
    [ RUN      ] "ToyRISC Refinement"
    Failed assertions:


    --------------------
    ToyRISC tests > ToyRISC Refinement
    FAILURE
    name:       check-unsat?
    location:   /serval/serval/lib/unittest.rkt:46:13
    params:
      '((model
       [X -1]
       [a0 -1]))
    --------------------
    0 success(es) 1 failure(s) 0 error(s) 1 test(s) run





<code>1</code>



As expected, we can observe the assertion failure for the modification we did and provides a counterexample to reproduce the error.


In conclusion, in this post, we looked at Serval verification framework with the objective of utilizing it for systems code verification. We looked at the simple example that comes with the Serval framework and executed it on Jupyter Notebook as an interactive proof. This same framework can be used for more complex verification scenarios to provide correctness guarantees for systems code.
