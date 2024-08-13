# Targets.jl

```julia
julia> using Targets

       # Define a function and some targets

julia> function add(x, y)
           println("Computing the sum of $x and $y")
           x + y
       end
add (generic function with 1 method)

julia> @target a = 1
Target(1, nothing, Symbol[], "6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b", true)

julia> @target b = 2
Target(2, nothing, Symbol[], "d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35", true)

julia> @target c = add(a, b)

       # Access target values
Target(nothing, :add, [:a, :b], "", false)

julia> @get c
Computing the sum of 1 and 2
3

julia> println("The value of c is: $c")

       # No computation if not needed
The value of c is: 3

julia> @get c
3

julia> println("The value of c is: $c")

       # Change the value of a
The value of c is: 3

julia> @target a = 10

       # Access c again (it will be automatically recomputed)
Target(10, nothing, Symbol[], "4a44dc15364204a80fe80e9039455cc1608281820fe2b24f1e5233ade6af1dd5", true)

julia> @get c
Computing the sum of 10 and 2
12

julia> println("The value of c is: $c")

       # Redefine the function
The value of c is: 12

julia> function add(x, y)
           println("Computing the sum of $x and 2*$y")
           x + 2*y
       end

       # Access c again (it will be automatically recomputed)
add (generic function with 1 method)

julia> @get c
Computing the sum of 10 and 2*2
14

julia> println("The value of c is: $c")
The value of c is: 14
```
