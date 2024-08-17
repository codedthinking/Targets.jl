using Test
using Targets

add(x, y) = x + y
add1(x) = x + 1
mult(x, y) = x * y

@testset "Targets" begin
    @testset "Basic functionality" begin
        @target a = 1
        @target b = 2
        @test (@get a) == 1
        @test (@get b) == 2

        @target c = add(a, b)
        @test (@get c) == 3
    end

    @testset "Updating values" begin
        @target x = 5
        @target y = add1(x)
        @test (@get y) == 6

        @target x = 10
        @test (@get y) == 11
    end

    @testset "Indirect updating" begin
        @target a = 1
        @target b = add1(a)
        @target c = add1(b)
        @test (@get c) == 3

        @target a = 2
        @test (@get c) == 4
    end

    @testset "Function modification" begin
        @target m = 3
        @target n = 4
        @target p = mult(m, n)
        @test (@get p) == 12

        # Modify the function
        Main.mult(x, y) = x * y + 1
        @test (@get p) == 13
    end

    @testset "Built-in function handling" begin
        @target a = 5
        @target b = 7
        @target sum_ab = +(a, b)
        @test (@get sum_ab) == 12

        @target a = 10
        @test (@get sum_ab) == 17
    end
end