module TestChecker
    using Calculus2
    using Base.Test

    # ---
    # Univariate
    # ---

    f(x::Real) = sin(x)
    g(x::Real) = cos(x)
    h(x::Real) = -sin(x)

    @test isgrad(g, f, 0.0)
    @test isgrad(g, f, 1.0)
    @test isgrad(g, f, 10.0)
    @test isgrad(g, f, 100.0)
    @test isgrad(g, f, 1000.0)

    @test ishess(h, f, 0.0)
    @test ishess(h, f, 1.0)
    @test ishess(h, f, 10.0)
    @test ishess(h, f, 100.0)
    @test ishess(h, f, 1000.0)

    # ---
    # Multivariate
    # ---

    f(x::Vector) = sin(x[1]) + cos(x[2])
    g(x::Vector) = [cos(x[1]), -sin(x[2])]
    function g!(gr::Vector, x::Vector)
    	gr[1] = cos(x[1])
    	gr[2] = -sin(x[2])
        return gr
    end
    h(x::Vector) = [
    	-sin(x[1]) 0.0;
    	0.0        -cos(x[2]);
    ]
    function h!(H::Matrix, x::Vector)
    	H[1, 1] = -sin(x[1])
    	H[1, 2] = 0.0
    	H[2, 1] = 0.0
    	H[2, 2] = -cos(x[2])
        return H
    end

    @test isgrad(g, f, [0.0, 0.0])
    @test isgrad(g, f, [1.0, 1.0])
    @test isgrad(g, f, [10.0, 10.0])
    @test isgrad(g, f, [100.0, 100.0])
    @test isgrad(g, f, [1000.0, 1000.0])
    @test isgrad!(g!, f, [0.0, 0.0])
    @test isgrad!(g!, f, [1.0, 1.0])
    @test isgrad!(g!, f, [10.0, 10.0])
    @test isgrad!(g!, f, [100.0, 100.0])
    @test isgrad!(g!, f, [1000.0, 1000.0])

    @test ishess(h, f, [0.0, 0.0])
    @test ishess(h, f, [1.0, 1.0])
    @test ishess(h, f, [10.0, 10.0])
    @test ishess(h, f, [100.0, 100.0])
    @test ishess(h, f, [1000.0, 1000.0])
    @test ishess!(h!, f, [0.0, 0.0])
    @test ishess!(h!, f, [1.0, 1.0])
    @test ishess!(h!, f, [10.0, 10.0])
    @test ishess!(h!, f, [100.0, 100.0])
    @test ishess!(h!, f, [1000.0, 1000.0])
end
