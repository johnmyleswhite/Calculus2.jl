module TestDeparse
    using Calculus2
    using Base.Test

    @test isequal(
        deparse(:(cos(x) + sin(x))),
        "cos(x) + sin(x)"
    )
    @test isequal(
        deparse(:(cos(x) + sin(x) + exp(-x))),
        "cos(x) + sin(x) + exp(-x)"
    )
    @test isequal(
        deparse(parse("x+y*z")),
        "x + y * z"
    )
    @test isequal(
        deparse(parse("(x+y)*z")),
        "(x + y) * z"
    )
    @test isequal(
        deparse(parse("1/(x/y)")),
        "1 / (x / y)"
    )
    @test isequal(
        deparse(parse("1/(x*y)")),
        "1 / (x * y)"
    )
    @test isequal(
        deparse(parse("z^(x+y)")),
        "z ^ (x + y)"
    )
    @test isequal(
        deparse(parse("z^(x*y)")),
        "z ^ (x * y)"
    )
end
