Racket101
====
<p align="center"><picture>
  <source srcset="https://raw.githubusercontent.com/Archfx/RACKETutes/main/images/racketutes-w.svg" media="(prefers-color-scheme: dark)">
    <img src="https://raw.githubusercontent.com/Archfx/RACKETutes/main/images/racketutes.svg">
  </picture></p>
  
In the previous post, we looked at setting up the environment for the tutorial series. In this post, we will be looking at basic Racket programming. At the end of the post, we will be doing some Racket programming exercises on the Jyputer environment.
Racket is a functional programming language created to avoid confusion in programming semantics. People familiar with javascript might be familiar with confusion in programming languages. Due to the mathematical nature of the syntaxes used, Racket is popular with the formal verification community. Racket comes with three components,

<img align="right" width="80" height="auto" alt="" src="{{ base_path }}/images/icons/racket.svg"/>

1. `racket` - compiler/ interpriter/ runtime
2. `DrRacket` - IDE
3. `raco` - package manager

In our tutorials, we will be using Racket inside the Jupyter Notebook environment. Setting up the environment with ease is discussed in my [previous post]().

This complete post is available as a Jupyter Notebook [here](https://github.com/Archfx/RACKETutes/blob/main/racket101/racket101.ipynb)

Usually, we need to start the rkt script with specifying the language variant. 


```Racket
#lang racket
```

    eval:1:0: read-syntax: `#lang` not enabled
      possible reason: not allowed again inside a module that already starts `#lang`, or not enabled for interactive evaluation
      context...:
       /usr/share/racket/pkgs/sandbox-lib/racket/sandbox.rkt:114:0: default-sandbox-reader
       /usr/share/racket/pkgs/sandbox-lib/racket/sandbox.rkt:572:0: input->code
       /usr/share/racket/pkgs/sandbox-lib/racket/sandbox.rkt:929:14


Ops! We got the error ``` read-syntax: `#lang` not enabled ```. This happens due to the kernel running behind the Jupyter. Therefore to use Racket on Jupyter Notebook, language variant specification should be like this.


```Racket
#lang iracket/lang #:require rosette
```

Interactiveness
----
All the features that you can enjoy while using dr.Racket can be enjoyed on Jupyter Notebook. Let's see some examples of function definitions, and racket drawings.


#### Function Outputs


The final variable that appears on a Racket function is considered as it's return value. This value gets printed directly to the output when you run a cell. 

Let's see some examples,

Racket has implementations of built-in functions for different [operations](https://docs.racket-lang.org/plait/built-ins-tutorial.html). Sample usage of built-in function `extract` given in the Racket documentation is as below.


```Racket
(define (extract str)
  (substring str 4 7))
(extract "the gal out of the city")
```




<code>"gal"</code>



#### Graphics

Racket has its own Drawing Toolkit. Output from the functions are directly displayed in Jupyter Notebook. First we need to import the modules as follows,




```Racket
 (require 2htdp/image)
```

Then we can start drawing


```Racket
(circle 30 "outline" "red")
```




<code><img style="display: inline; vertical-align: baseline; padding: 0pt; margin: 0pt; border: 0pt" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADwAAAA8CAYAAAA6/NlyAAAE2ElEQVRogeXbX6wdVRUG8N+e
3lZiaemfGAitIq1tKcJDY2xpiKAvEoUCSSWGByAE/EMixNLGJgrxQaORBEwwEQj4QMRIgjE1
UYygIBhBiFL+hNKmLShoKcWgtSg+CJ8PM1doL+Xee86cM3j4kslJZubs/X17rZnZe621SxID
QSkz8WGsxnJ8AMdhLt7d/P4DL2M/dmEHtuE3kl0DodWq4FIW4jysxxq1iAewHTvxjFrcvyQH
lDIXszFPPSjLcTI+huAX+AHul7zWCsck/R+cFraEv4cfhnPDUX22uSxsCI+EZ8NVYX6/XPsV
+vHwQNgRPhuObGUAJ/ZzUvhe+Gu4ph/hvRJY0lh0R1gfqoEIndjv4nBDeD5c0ku/vXT6+fBi
2BxmDUXoRA6rGs/6dVg0GMHMCz8Ovw/LOhF6MJ8qfLmx9lntCq5d6YlwfWdWPTy3teG5cEU7
glkZ/hSu7Fzc4Tm+LzzZvNBK74I5vvkkXNC5qMlFzw8PhW/2Jpijw85wWedipi56QfPofWl6
gpkR7glf61zE9EUfG/4Y1k1H8NfDr8KMzgX0Jnp12BuWTC6YNeEv4T2dE+9P9BXhwUMnJ9Uh
k/8ZuAGbJC+2MlnvDt/BK/jcQWcPGZUvhLs6t057Vj4x7AvHjJ97fXlYyrvUy7mzJVuHbI3B
oZTrUEm+iIMEX4ZPSM7ujt0AUMoxeBInS/a88Rm+HNd0w2qASPbi+2p9jYVLWY3bsML/TD5C
KGUZ7sd7xy18AW4dSbGQ7MTTOGPcwruxTrKtY2qDQ/2OWlvC+9WBtkUja2Eo5Xj8tsLpuHek
xULyDF6p8EE83jGdYeG+Cieo48bvBDxVYal6hvVOwPZKHfV/qWsmQ8LuSp3jOdA1kyFhfwmv
Yqa2cjdvZ5Qyp4TXJNXkd48AShmrMPqWfR2za8uWUjomMizMqdT52gVdMxkSFlbYg2O7ZjIk
rKjwZyzumsmQsLLCE1jVNZMhYVWFh9WFJ6ONUsZw+rjgU5Qy6t/iNXi6kjyLfTilY0KDxnr8
bDzE81XMlWzsmtVAUMosPIdTx934DpzX+PkoYh22SXbVguvg3W612UcL9SxyszrXdFAy7dvY
1AWnAeMsHIEt8MbEUxW2hU92ngRrL5k2Fh4L50xMl9br4U24tikMHQVswPOSn4yfmFhcWsrP
8UvJtcPl1jJKWYKHsLoJ0dZ4EzdY2uRUT+rcJXt35SOaArrLD7325uXDpVyEjc3o/HtINmkP
pdyEeZJPT7h02IRDKbdhDOf/X2UlStmIi7FWMjE4+RZuMaspXfpG5y46dVe+sKkaPO5w90zW
wMLwVPhK52ImF3tpU330loWvU2no6PBo+NZkdYwdit0cdoflk907tT0PpSzAneo9C5+RvNzu
g9cjSjkKN6s3j6yT7JvsL1NbAycv4aP4J36nlJW9s2wJpazBI9iL06YiFj1VxF/afKevCjM7
cN/54bthTzh3uv+ffpQjuQUfUoeFtirlnKHEtUuZrZQN6n1N/8GJki3TbqfP0T4z/KE5PjWQ
ankWhavDC+H2fmeAbRAqqfcp3dOQui6cGsb6aHNxuDjcnXrrzo1hRRsD2PbOtKW4CGdiCe7D
1sYNt+NvOCDZ37xhj8Qc9Ta9E5rjI+qc9b34EX6qxentfwGeYLF3HKscIAAAAABJRU5ErkJg
gg==
"/></code>




```Racket
(add-line
    (rectangle 100 100 "solid" "darkolivegreen")
    25 25 75 75
    (make-pen "goldenrod" 30 "solid" "round" "round"))
```




<code><img style="display: inline; vertical-align: baseline; padding: 0pt; margin: 0pt; border: 0pt" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAEi0lEQVR4nO2dQW8bRRiGn7W9
sZO4kMYXJxWouMJBTRHHBOXIsUpv0FbwD/hftFwpvSIhUSk5k7aqUUMlaOqL01Q4ie21vRxC
IG0SMrue3Z3Z+Z57vO/42flmZq1863357WchgjEUsg4gvI0IMQwRYhgixDBEiGGIEMMQIYYh
QgxDhBhGSeeHFT24NhfQnBtypTpmvjKiUjx6ENAbeez2irzsFmjtlXi+5zOSZwSn0CKkXIS1
xR4r9QFV/+xvuVoIqfpDPrwEny8M6AYem+0pHu1U6I90pMgHEwu5URuy3jg4V8R5VP2QLz7o
s1If8GB7hq2O1slqLbHXkIIXcqvR4+7SfmQZJ6n6IXeX9rnV6FHwpIbFElLwQm43D1ip97UF
Wan3udM8pOhp+0griSXk5tU+N2pD3VlYrgXcWTpwWkpkIcu1gNUFfTPjXa7PB3zzyQElRzfk
kYZdLsL6R4dJZfmX5uWAr5fclBJpyGuLPS5NpbPwNi8H3G66V76UhRQ9WKkPksxyChfLl/JQ
r80FE21v4+LaTFEW0pzTv6tS5fq8O7svZSFXquMkc1yIK+VLeXjzlewfOLlQvpSFHD+1zZq8
zxQrh5Xnc4rykHojs+pEXsuXspDdXjHJHLHIY/lSHsrLrpmjzttMUf6WW3vm/oCUp3OKspDn
ez7dwNwR56V8KccfhbDZnkoyy8TkoXxFup9+2anw18Ds0do+UyLFHozgwe/TSWXRhs3nlMiR
H3d8Nl6Vk8iiFVvLV6x76OGLMo87vu4s2rFx9xVLyDj0uN+a4emuHVJsWlNixxyH8N0zO6TY
tKZMFFGk6GfieCJFL1qiiRR9aIslUvSgNZJImRztcUTKZCQSRaTEJ7EYIiUeiUYQKdFJ/PIi
JRqpXFqkqJPaZUWKGqleUqRcTOr3gEj5fzKplCLlfDLbT4iUs8l01y1STpP52VSkvE3mQkCk
nMQIISBSjjFGCIgUMEwIiBTjhIDbUowUAu5KMVYIuCnFaCHgnhTjhcCRlHvPZnhiiZSvPj6I
3a7QCiFw9B9c9y2RslwLuHk1XpM3a4TAkZR7lpSv1YU+n9aCyH9nlRCwa01ZbxxSjtiSxDoh
YM+aMuuHrC1GK11WCgF7ytdqfRBp12WtELBjpsz6IY331dcSq4WAHbuvKN34rBcC5pevxVn1
5m+5EAJml6/atHp7xNwIAXNnSpRufLkSAnadU84id0LAvPIVpRtfLoWAWeWrc6j+NedWCJgz
U3b21dsj5loImHFOidKNL/dCINvytR94bL9Rv64TQiC78rXRnmIYoUu7M0Ig/ZnSDTwe7UTr
LeaUEEj3nPLj9jT9iA2onRMC6ZSvjVdlfo3R5M1JIfDf7iuJznhbnRIPX8Rrg+isEPhHSmua
zba+HpKb7TLft2YYh/H6CprbrjolxqHHD9sVtt+UYr1C9phu4Gl5hazzQo7Z6pT4be+9C1+y
/C66X7IsQk7QH8FPf1T4+c9KZq8hFyFnMAqh9dqn9Tr9k73Ti7qJiBDDECGGIUIMQ4QYhggx
DBFiGCLEMESIYfwN+JFttSFHVkAAAAAASUVORK5CYII=
"/></code>




```Racket
 (require lang/posn)

(underlay
   (rectangle 80 80 "solid" "mediumseagreen")
   (polygon
    (list (make-posn 0 0)
          (make-posn 50 0)
          (make-posn 0 50)
          (make-posn 50 50))
    "outline"
    (make-pen "darkslategray" 10 "solid" "round" "round")))
```




<code><img style="display: inline; vertical-align: baseline; padding: 0pt; margin: 0pt; border: 0pt" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAFAAAABQCAYAAACOEfKtAAADNElEQVR4nO3cQWvbMBQH8L/T
1A45NKHptlPuhayQQ+kK25faZ9tnGJSyQyEb5B7ooSyjySGJnaTeIfFWBit6epKenL7/ucbS
D7uWnqQkn758LqGxTkO6AXWPAjKjgMwoIDMKyIwCMqOAzCggMwrITJN6wWayQDGa4elhhXJz
GJOYpJmg8baF9KKDZr9NupYEWHz7hfzukXSDOqTclNjeL7G8XyIbdpFenhpfa/wKbyaLg8T7
N/ndIzaThfHfGwMWo5lVg+oYSl+NAZ8eVlaNqWMofTX/CieJTVtqmbJh3ldjwMabzKoxdczR
mXlfjQHTi45VY+oYSl+NAZv99qtApI4FSTOR7KqH9P3hIh6fnyC76pGuoc1EEiD7sLtB8Z0+
rDk+P0Hr4xng63tUAvnNFMWPcG2jz4X3iDZP4no8x+rrT8DHDFAAD7AtJsSGKIQHcKoxsSAK
4gHccpY0ojAe4KIeKIUYAR7gqqAaGjESPMBlRToUYkR4gOuSvm/EyPAAH2sivhAjxAN8LSq5
RowUD7BYVDIOY9q3Hs8BYNdxxIsH+AQE/iKWIAOsx3MkR7ue2+Clgw6y655XPMA3ILBD3HeE
+iTawAH7qkoAPCDUwjrjfyI1IV7b5wm3MyEAYmg8IPTWDo+IEniAxN4YD4hSeIDU5iKHiJJ4
QIiv8P/CGOJUCTVUeSm13t5WbuV3h8kBMqZnVbyusRhGBtABXhVpxPCADvGqSCKGBfSAV0UK
MRygR7wqEohhAAPgVQmN6B+QgZcOOkgHdkXZ/GYaBNHvQJpZSc6u9xt9LEth5bascUHVYRne
SWXbE6KfV9j1Gob0DogX4h7Q1wJQpIhuAX2vnkWI6A4w1NJjZIhuAEOv20aEyAeUWvSOBJEH
KL1jIAJEe0BpvCrCiHaAseBVEUSkA8aGV0UIkTaVY1ZV1uP5n+lVbLGd9pGewPw2TElKKuvx
HPntlHQN6cT6azh0XYxmemKdGz2xzoyeWGdGT6wzoyfWmfF2Yj0bdq0aVKdkwy7pxDppIJ1e
nqLxrqU//fQs5EWlZr9Nvskhp9bb22KIAjKjgMwoIDMKyIwCMqOAzCggMwrIzG/PDzkTTq4j
2wAAAABJRU5ErkJggg==
"/></code>



Conclusion
----

From here onwards, we will be looking at a bunch of example Racket programs that you can try on the Jupyter Notebook environment. In the next post, we will look at [Rosette](https://docs.racket-lang.org/rosette-guide), which is a solver-aided programming language that is based on Racket.

#### Racket Play Ground

Constructing the popular Pascal triangle with Racket

> First we need to write a function to compute the factorial of a number


```Racket
; Compute the factorial of a number
(define (factorial n)
    (define mult 1)
    (for ([i (in-range 1 n)]) 
        (set! mult (* i mult)))
        mult)

```

> Then, we can construct the Pascal triangle


```Racket
; Construct the Pascal triangle
(define (pascal n)
    (for ([i (in-range 0 n)])
        (for ([q (in-range 0 (+ (- n i) 1))])
            (display " ") )
        (for ([j (in-range 0 (+ i 1))])
            (display (/ (factorial i) (* (factorial j) (factorial (- i j))))) 
            (display " "))
            
    (displayln "" )))
```

> Ofcource we need to test it


```Racket
(pascal 5)
```

          1 
         1 1 
        1 1 1 
       1 2 2 1 
      1 3 6 3 1 


#### Answers to the problems from [here](https://cs.brown.edu/courses/cs019/2010/assignments/practice.html)


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

