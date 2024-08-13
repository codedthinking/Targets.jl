# Targets.jl

Targets.jl is a Julia package for defining and managing computational targets, inspired by the `targets` library in R. It provides a simple way to create reproducible and efficient data pipelines by automatically tracking dependencies and caching results.

## Features

- Define targets using the `@target` macro
- Automatically track dependencies between targets
- Cache computed results to avoid unnecessary recomputation
- Automatically recompute targets when dependencies change
- Support for both simple values and function-based targets

## Example Usage

```julia
using Targets

# Define a function and some targets
function add(x, y)
    println("Computing the sum of $x and $y")
    x + y
end

@target a = 1
@target b = 2
@target c = add(a, b)

# Access target values
@get c  # Computes and caches the result
println("The value of c is: $c")

# Change a dependency
@target a = 10

# Access c again (it will be automatically recomputed)
@get c

# Redefine the function
function add(x, y)
    println("Computing the sum of $x and 2*$y")
    x + 2*y
end

# Access c again (it will be automatically recomputed)
@get c
```

Targets.jl simplifies the process of creating data pipelines by managing dependencies and caching results, making your workflow more efficient and reproducible.