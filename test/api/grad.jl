module TestGrad
    using Calculus2
    using Base.Test

    # multivariate test function
    function f(x::Vector)
        return sin(x[1]) + cos(x[2])
    end
    x = [0.0, 0.0]
    gr = similar(x)

    # Test in-place multivariate grad!
    grad!(gr, f, x)
    @test norm(gr - [cos(0.0), -sin(0.0)]) < 10e-8
    fill!(gr, 0.0)

    grad!(gr, f, x, method = :ad)
    @test norm(gr - [cos(0.0), -sin(0.0)]) < 10e-8
    fill!(gr, 0.0)

    ∇!(gr, f, x)
    @test norm(gr - [cos(0.0), -sin(0.0)]) < 10e-8
    fill!(gr, 0.0)

    # Test pure multivariate grad
    @test norm(grad(f, x) - [cos(0.0), sin(0.0)]) < 10e-8
    @test norm(∇(f, x) - [cos(0.0), sin(0.0)]) < 10e-8

    # Test in-place multivariate gradfunc!
    ∇f! = gradfunc!(f, x)
    ∇f!(gr, x)
    @test norm(gr - [cos(0.0), sin(0.0)]) < 10e-8

    # Test in-place multivariate gradfunc!
    ∇f! = gradfunc!(f, x, method = :ad)
    ∇f!(gr, x)
    @test norm(gr - [cos(0.0), sin(0.0)]) < 10e-8

    # Test pure multivariate gradfunc
    ∇f = gradfunc(f, x)
    @test norm(∇f(x) - [cos(0.0), sin(0.0)]) < 10e-8

    # Test pure univariate grad
    @test isapprox(grad(sin, 0.0), cos(0.0))
    @test isapprox(grad(sin, 0.0, method = :ad), cos(0.0))

    # Test pure univariate gradfunc
    @test isapprox(gradfunc(sin, 0.0)(0.0), cos(0.0))
    @test isapprox(gradfunc(sin, 0.0, method = :ad)(0.0), cos(0.0))

    # TODO: Test automatic differentation
    # TODO: Test symbolic differentiation
    # TODO: Test direction options
end
