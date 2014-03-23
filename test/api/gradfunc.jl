module TestGradfunc
    using Calculus2
    using Base.Test

    f(x) = sin(x)
    g(x) = @gradfunc(sin(x), x)
    h(x) = @hessfunc(sin(x), x)

    f(1.0)
    g(1.0)
    h(1.0)

    f(z) = 1 / (1 + exp(-z))
    g(z) = @gradfunc(1 / (1 + exp(-z)), z)

    @test isapprox(
        g(0.0),
        grad(f, 0.0)
    )

    @test isapprox(
        g(1.0),
        grad(f, 1.0)
    )

    f(x) = sin(x) + cos(x)^2 + sin(x)^3
    g(x) = @gradfunc(sin(x) + cos(x)^2 + sin(x)^3, x)

    @test isapprox(
        g(0.0),
        grad(f, 0.0)
    )

    @test isapprox(
        g(1.0),
        grad(f, 1.0)
    )

    # NB: This won't work for multivariate functions
    f(x) = sin(x) + cos(x)^2 + sin(x)^3
    grad(f, 1.0, method = :finite)
    grad(f, 1.0, method = :ad)
    gradfunc(f, 1.0, method = :finite)(1.0)
    gradfunc(f, 1.0, method = :ad)(1.0)
    g(x) = @gradfunc(sin(x) + cos(x)^2 + sin(x)^3, x)
    g(1.0)
    hess(f, 1.0, method = :finite)
    hessfunc(f, 1.0, method = :finite)(1.0)
    h(x) = @hessfunc(sin(x) + cos(x)^2 + sin(x)^3, x)
    h(1.0)
end
