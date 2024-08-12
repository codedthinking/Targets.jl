using Targets

# Define a function and some targets
add(x, y) = x + y
@target a = 1
@target b = 2
@target c = add(a, b)

# Access target values
println("The value of c is: ", c.value)

# Change the value of a
@target a = 10

# Access c again (it will be automatically recomputed)
println("The new value of c is: ", c.value)

# Define a more complex target
multiply_add(x, y, z) = x * y + z
@target d = multiply_add(a, b, c)

println("The value of d is: ", d.value)

# Change the add function
add(x, y) = x - y

# Access c and d again (they will be automatically recomputed)
println("The new value of c is: ", c.value)
println("The new value of d is: ", d.value)