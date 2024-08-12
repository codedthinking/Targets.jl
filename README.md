# Targets.jl

```julia
julia> using Targets
Precompiling Targets
  1 dependency successfully precompiled in 1 seconds. 1 already precompiled.

julia> function add(x, y)
       println("Computing sum of $x and $y")
       x + y
       end
add (generic function with 1 method)

julia> @target a = 1
Target(1, nothing, Symbol[], "6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b", true)

julia> @target b = 2
Target(2, nothing, Symbol[], "d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35", true)

julia> @target c = add(a, b)
Target(nothing, :add, [:a, :b], "", false)

julia> c |> get_value
Computing sum of 1 and 2
3

julia> c |> get_value
3

julia> @target b = 4
Target(4, nothing, Symbol[], "4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a", true)

julia> c |> get_value
Computing sum of 1 and 4
5

julia> function add(x, y)
       println("Computing sum of $x and 2*$y")
       x + 2 * y
       end
add (generic function with 1 method)

julia> c |> get_value
Computing sum of 1 and 2*4
9
```
