using Test
using Targets

@testset "Targets" begin
    @testset "Basic functionality" begin
        @target a = 1
        @target b = 2
        @test get_value(a) == 1
        @test get_value(b) == 2

        add(x, y) = x + y
        @target c = add(a, b)
        @test get_value(c) == 3
    end

    @testset "Updating values" begin
        @target x = 5
        @target y = x + 1
        @test get_value(y) == 6

        @target x = 10
        @test get_value(y) == 11
    end

    @testset "Function modification" begin
        mult(x, y) = x * y
        @target m = 3
        @target n = 4
        @target p = mult(m, n)
        @test get_value(p) == 12

        # Modify the function
        mult(x, y) = x * y + 1
        @test get_value(p) == 13
    end

    @testset "Complex dependencies" begin
        @target base = 2
        @target exp = 3
        pow(x, y) = x^y
        @target result = pow(base, exp)
        @test get_value(result) == 8

        @target base = 3
        @test get_value(result) == 27
    end

    @testset "Reset functionality" begin
        @target to_reset = 42
        @test get_value(to_reset) == 42

        reset_targets!()
        @test_throws UndefVarError get_value(to_reset)
    end

    @testset "Error handling" begin
        @test_throws ErrorException @target error_case = nonexistent_function(1, 2)
    end

    @testset "Built-in function handling" begin
        @target a = 5
        @target b = 7
        @target sum_ab = +(a, b)
        @test get_value(sum_ab) == 12

        @target a = 10
        @test get_value(sum_ab) == 17
    end
end