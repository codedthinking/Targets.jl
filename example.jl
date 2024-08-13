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
@get c
println("The value of c is: $c")

# No computation if not needed
@get c
println("The value of c is: $c")

# Change the value of a
@target a = 10

# Access c again (it will be automatically recomputed)
@get c
println("The value of c is: $c")

# Redefine the function
function add(x, y)
    println("Computing the sum of $x and 2*$y")
    x + 2*y
end

# Access c again (it will be automatically recomputed)
@get c
println("The value of c is: $c")
