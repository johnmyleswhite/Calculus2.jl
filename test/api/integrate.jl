module TestIntegrate
    using Calculus2
    using Base.Test

    @test isapprox(
        integrate(x -> 1 / x, 1.0, 2.0),
        log(2) - log(1)
    )

    @test isapprox(
        integrate(x -> -sin(x), 0.0, pi),
        (cos(pi) - cos(0.0))
    )

    @test isapprox(
        integrate(x -> 1, 0, 1),
        1.0 - 0.0,
    )

    @test isapprox(
        integrate(x -> x, 0, 1),
        1//2 * 1.0^2 - 1//2 * 0.0^2
    )

    @test isapprox(
        integrate(x -> x * x, 0, 1),
        1//3 * 1.0^3 - 1//3 * 0.0^3 
    )

    @test isapprox(
        integrate(sin, 0, pi),
        -cos(pi) - (-cos(0))
    )

    @test isapprox(
        integrate(cos, 0, pi),
        sin(pi) - sin(0)
    )

    @test isapprox(
        integrate(x -> sin(x)^2 + sin(x)^2, 0, pi),
        pi
    )

    @test isapprox(
        integrate(x -> 1 / x, 0.01, 1),
        4.60517
    )

    @test isapprox(
        integrate(x -> cos(x)^8, 0, 2 * pi),
        35 * pi / 64
    )

    @test isapprox(
        integrate(x -> sin(x) - sin(x^2) + sin(x^3), pi, 2 * pi),
        -1.830467
    )

    @test isapprox(
        integrate(sin, 0.0, pi, method = :quadrature),
        sqrt(2),
        atol = 10e-1
    )

    @test isapprox(
        integrate(sin, 0.0, pi, method = :simpsons),
        sqrt(2),
        atol = 10e-1
    )

    @test isapprox(
        integrate(sin, 0.0, pi, method = :monte_carlo),
        sqrt(2),
        atol = 10e-1
    )

    @test isapprox(
        ∫(cos, 0.0, 1.0),
        sin(1.0) - sin(0.0)
    )
end
