module TestSymbolic
    using Calculus2
    using Base.Test

    #
    # Univariate Calculus
    #

    @test isequal(gradexpr(:(2), :x), 0)
    @test isequal(gradexpr(:(x), :x), 1)
    @test isequal(gradexpr(:(x + x), :x), 2)
    @test isequal(gradexpr(:(x - x), :x), 0)
    @test isequal(gradexpr(:(2 * x), :x), 2)
    @test isequal(gradexpr(:(2 / x), :x), :(-2 / x^2))
    @test isequal(gradexpr(:(x / 2), :x), 0.5)
    @test isequal(gradexpr(:(sin(x) / x), :x), :((cos(x) * x - sin(x)) / x^2))
    @test isequal(gradexpr(:(x * 2), :x), 2)
    @test isequal(gradexpr(:(a * x), :x), :a)
    @test isequal(gradexpr(:(x * a), :x), :a)
    @test isequal(gradexpr(:(x ^ 2), :x), :(2 * x))
    @test isequal(gradexpr(:(a * x ^ 2), :x), :(a * (2 * x)))
    @test isequal(gradexpr(:(2 ^ x), :x), :(*(0.6931471805599453, ^(2, x))))
    @test isequal(gradexpr(:(sin(x)), :x), :(cos(x)))
    @test isequal(gradexpr(:(cos(x)), :x), :(-sin(x)))
    @test isequal(gradexpr(:(tan(x)), :x), :(1 + tan(x)^2))
    @test isequal(gradexpr(:(exp(x)), :x), :(exp(x)))
    @test isequal(gradexpr(:(log(x)), :x), :(1 / x))
    @test isequal(gradexpr(:(sin(x) + sin(x)), :x), :(cos(x) + cos(x)))
    @test isequal(gradexpr(:(sin(x) - cos(x)), :x), :(cos(x) + sin(x)))
    @test isequal(gradexpr(:(x * sin(x)), :x), :(sin(x) + x * cos(x)))
    @test isequal(gradexpr(:(x / sin(x)), :x), :((sin(x) - x * cos(x)) / (sin(x)^2)))
    @test isequal(gradexpr(:(sin(sin(x))), :x), :(*(cos(x),cos(sin(x)))))
    @test isequal(gradexpr(:(sin(cos(x) + sin(x))), :x), :(*(+(-sin(x),cos(x)),cos(+(cos(x),sin(x))))))
    @test isequal(gradexpr(:(exp(-x)), :x), :(-exp(-x)))
    @test isequal(gradexpr(:(log(x^2)), :x), :(/(*(2,x),^(x,2))))
    @test isequal(gradexpr(:(x^n), :x), :(*(n, ^(x, -(n, 1)))))
    @test isequal(gradexpr(:(n^x), :x), :(*(^(n, x), log(n))))
    @test isequal(gradexpr(:(n^n), :x), 0)

    #
    # Multivariate Calculus
    #

    @test isequal(gradexpr(:(sin(x) + sin(y)), [:x, :y]), [:(cos(x)), :(cos(y))])
    @test isequal(gradexpr(:(x^2), [:x, :y]), {:(2*x), 0})

    # TODO: Get the generalized power rule right.
    # @test isequal(gradexpr(:(sin(x)^2), :x), :(2 * sin(x) * cos(x)))

    # TODO: Make these work
    # gradexpr(:(sin(x)), :x)(0.0)
    # gradexpr(:(sin(x)), :x)(1.0)
    # gradexpr(:(sin(x)), :x)(pi)

    #
    # SymbolicVariable use
    #

    x = BasicVariable(:x)
    y = BasicVariable(:y)

    @test isequal(@sexpr(x + y), :($x + $y))
    @test isequal(gradexpr(@sexpr(3 * x), x), 3)
    @test isequal(gradexpr(:(sin(sin(x))), :x), :(*(cos(x),cos(sin(x)))))
    @test isequal(gradexpr(@sexpr(sin(sin(x))), x), :(*(cos($x),cos(sin($x)))))

    function testfun(x)
        z = BasicVariable(:z)
        gradexpr(@sexpr(3*x + x^2*z), z)
    end

    @test isequal(testfun(x), :(^($(x),2)))
    @test isequal(testfun(3), 9)
    @test isequal(testfun(@sexpr(x+y)), :(^(+($x,$y),2)))

    #
    # Simplify tests
    #

    @test isequal(simplify(:(x+y)), :(+(x,y)))
    @test isequal(simplify(:(x+3)), :(+(3,x)))
    @test isequal(simplify(:(x+3+4)), :(+(7,x)))
    @test isequal(simplify(:(2+y+x+3)), :(+(5,y,x)))

    @test isequal(simplify(:(x*y)), :(*(x,y)))
    @test isequal(simplify(:(x*3)), :(*(3,x)))
    @test isequal(simplify(:(x*3*4)), :(*(12,x)))
    @test isequal(simplify(:(2*y*x*3)), :(*(6,y,x)))
end
