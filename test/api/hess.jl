module TestHess
    using Calculus2
    using Base.Test

    # multivariate test function
    function f(x::Vector)
        return sin(x[1]) + cos(x[2])
    end
    x = [0.0, 0.0]
    n = length(x)
    H = Array(eltype(x), n, n)

    # Test in-place multivariate grad!
    hess!(H, f, x)
    @test Calculus2.maxdiff(
        H,
        [-sin(0.0) 0.0; 0.0 -cos(0.0)]
    ) < 10e-8

    # Test pure multivariate grad
    @test Calculus2.maxdiff(
        hess(f, x),
        [-sin(0.0) 0.0; 0.0 -cos(0.0)]
    ) < 10e-8

    # Test in-place multivariate gradfunc!
    fill!(H, 0.0)
    h! = hessfunc!(f, x)
    h!(H, x)
    @test Calculus2.maxdiff(
        H,
        [-sin(0.0) 0.0; 0.0 -cos(0.0)]
    ) < 10e-8

    # Test pure multivariate gradfunc
    h = hessfunc(f, x)
    @test Calculus2.maxdiff(
        h(x),
        [-sin(0.0) 0.0; 0.0 -cos(0.0)]
    ) < 10e-8

    # Test pure univariate grad
    @test isapprox(hess(sin, 1.0), -sin(1.0))

    # Test pure univariate gradfunc
    @test isapprox(hessfunc(sin, 0.0)(1.0), -sin(1.0))

    # TODO: Test automatic differentation
    # TODO: Test symbolic differentiation
    # TODO: Test direction options
end
