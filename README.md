Calculus2.jl
============

A revision of the Calculus.jl package with a simplified interface that allows
users to easily switch between (a) pure and mutating functions and (b)
finite-differencing and automatic differentiation. Once the interface for this
package is standardized, it will be submitted as a pull request against
the official package, Calculus.jl.

# The Core Functions: `grad` and `hess`

### Univariate Functions

To evaluate the gradient of a univariate function, use the `grad` function:

```
using Calculus2

grad(sin, 1.0)
```

To compute the hessian of a univariate function, use the `hess` function:

```
hess(sin, 1.0)
```

### Multivariate Functions

The `grad` and `hess` functions also apply to multivariate functions:

```
f(x) = (10 - x[1])^2 + (5 - x[2])^2

x = [0.0, 0.0]

grad(f, x)
hess(f, x)
```

When working with multivariate functions, you often want to mutate an existing
array rather than allocate a new array to store the gradient and hessian. To do
this, use the `grad!` and `hess!` functions:

```
f(x) = (10 - x[1])^2 + (5 - x[2])^2

x = [0.0, 0.0]
n = length(x)
gr = similar(x, n)
H = similar(x, n, n)

grad!(gr, f, x)
hess!(H, f, x)
```

### Fine-Grained Control over `grad`, `hess`, `grad!` and `hess!`

By default, `grad` and `hess` use
[central finite-differencing](http://en.wikipedia.org/wiki/Finite_difference)
to compute approximate derivatives. You can change this default using the
`method` and `direction` keyword arguments:

```
grad(sin, 1.0, method = :finite, direction = :central)
grad(sin, 1.0, method = :finite, direction = :forward)
grad(sin, 1.0, method = :finite, direction = :reverse)
grad(sin, 1.0, method = :finite, direction = :complex)

grad(sin, 1.0, method = :ad)

hess(sin, 1.0, method = :finite, direction = :central)
```

At the moment, `hess` only supports `method = :finite` and
`direction = :central`. 

The `method` and `direction` keyword arguments also apply in the multivariate
case:

```
f(x) = (10 - x[1])^2 + (5 - x[2])^2

x = [0.0, 0.0]

grad(f, x, method = :finite, direction = :central)
grad(f, x, method = :finite, direction = :forward)
grad(f, x, method = :finite, direction = :reverse)

grad(f, x, method = :ad)

hess(f, x, method = :finite, direction = :central)

n = length(x)
gr = similar(x, n)
H = similar(x, n, n)

grad!(gr, f, x, method = :finite, direction = :central)
grad!(gr, f, x, method = :finite, direction = :forward)
grad!(gr, f, x, method = :finite, direction = :reverse)

grad!(gr, f, x, method = :ad)

hess!(H, f, x, method = :finite, direction = :central)
```

At the moment, multivariate `grad` and `grad!` do not support
`direction = :complex`. And, as in the univariate case, `hess` and `hess!`
only support `method = :finite` and `direction = :central`.

# Functions that Generate Functions: `gradfunc` and `hessfunc`

In many cases, it is convenient to construct a new function `g` that evaluates
the gradient of `f` without having to call the `grad` function each time.
To do this, use `gradfunc` or `gradfunc!`:

```
g = gradfunc(sin, 1.0)
g(1.0)

g = gradfunc(f, [0.0, 0.0])
g([0.0, 0.0])

g! = gradfunc!(f, [0.0, 0.0])
g!(gr, [0.0, 0.0])
```

Note that `gradfunc` and `gradfunc!` take in a specific point in the domain
of `f`. This is done to determine the type and size of the inputs the
resulting function `g` will accept as an argument.

For computing hessians, use `hessfunc` and `hessfunc!` instead:

```
h = hessfunc(sin, 1.0)
h(1.0)

h = hessfunc(f, [0.0, 0.0])
h([0.0, 0.0])

h! = hessfunc!(f, [0.0, 0.0])
h!(H, [0.0, 0.0])
```

`gradfunc`, `gradfunc!`, `hessfunc` and `hessfunc!` all take the same
`method` and `direction` arguments that their counterparts accept:

```
g = gradfunc(sin, 1.0, method = :ad)
g(1.0)

g = gradfunc(f, [0.0, 0.0], method = :ad)
g([0.0, 0.0])

g! = gradfunc!(f, [0.0, 0.0], method = :ad)
g!(gr, [0.0, 0.0])
```

# Symbolic Differentiation

All of the functions described earlier assume that you have a function in
hand of type `Function`. In some cases, you may wish to perform symbolic
calculus on objects of type `Expr`. For these cases, use the `gradexpr`
and `hessexpr` functions:

```
gradexpr(:(sin(x)), :x)
gradexpr(:(sin(x) + cos(y)), [:x, :y])

hessexpr(:(sin(x)), :x)
hessexpr(:(sin(x) + cos(y)), [:x, :y])
```

As you can see, these functions will generate either (1) a single new
expression if your input expression is a function of a single variable or (2)
an array of new expressions if your input expression is a function of many
variables.

To render the resulting expressions in a format that's easier for
humans to read, you can use the `deparse` function:

```
deparse(gradexpr(:(sin(x)), :x))
```

Operating on symbolic expressions is a powerful tool, but you may also wish
to use the symbolic manipulation functions to define new functions. For
univariate functions, this can be done using the `@gradexpr` and `@hessexpr`
macros:

```
newg(x) = @gradexpr(sin(x), x)
newg(1.0)

newh(x) = @hessexpr(sin(x), x)
newh(1.0)
```

At the moment, you can only use these macros with functions of a single
variable.

# Checking the Correctness of Analytic Gradients and Hessians

To achieve peak performance, it is often necessary to derive gradients and
hessians by hand and then manually implement the derived expressions. Because
the code for gradients and hessians tends to be long, it is helpful to have
tools that allow one to check the accuracy of hand-coded gradient and hessian
implementations. You can check a proposed gradient function using the
`isgrad` and `ishess` functions, which take in a proposed gradient
function, a source function and a point at which to test the proposal against
an automatically generated alternative:

```
isgrad(cos, sin, 0.0)
ishess(x -> -x^(-2), log, 1.0)
```

These functions also allow to multivariate outputs:

```
f(x) = sin(x[1])
g(x) = [cos(x[1])]
function g!(gr, x)
    gr[1] = cos(x[1])
    return gr
end
h(x) = [-sin(x[1])]
function h!(H, x)
    H[1] = -sin(x[1])
    return H
end

x = [1.0]

isgrad(g, f, x)
isgrad!(g!, f, x)

ishess(h, f, x)
ishess!(h!, f, x)
```

# Integration

In addition to supporting differentiation, the Calculus2 package supports
integration. To estimate the definite integral of a univariate function over
the interval $[a, b]$, use the `integrate` function:

```
integrate(x -> x^2, 0.0, 3.0)
```

By default, the `integrate` function just wraps the `quadqk` function in Base
Julia. In cases when you would like to use another method, you can specify
these using the method keyword:

```
integrate(x -> x^2, 0.0, 3.0, method = :simpsons)
integrate(x -> x^2, 0.0, 3.0, method = :monte_carlo)
```

In general, `quadgk` is substantially superior to these other methods and
should be preferred to them.

# Fun with Unicode

For those who like Unicode math, we have defined the nabla character, `∇`,
to mean `grad` and the integral character, `∫`, to mean `integrate`. In
addition, we support `∇!` for evaluting `grad!`:

```
∇(x -> x^2, 3.0)
∫(x -> x^2, 0.0, 3.0)

f(x) = sin(x[1])
x = [1.0]
gr = similar(x)
∇!(gr, f, [1.0])
```

For those who really want to push on Unicode, you could also overload the
`ctranspose` function to mean `gradfunc` as well:

```
Base.ctranspose(f::Function) = gradfunc(f, 0.0)
sin'(0.0)
```

We no longer do this because it does not generalize properly to multivariate
functions.

# Credits

Calculus2.jl is built on contributions from:

* John Myles White
* Tim Holy
* Andreas Noack Jensen
* Nathaniel Daw
* Blake Johnson
* Avik Sengupta
* Theodore Papamarkou

And draws inspiration and ideas from:

* Mark Schmidt
* Jonas Rauch
