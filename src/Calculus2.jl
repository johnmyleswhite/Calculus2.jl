module Calculus2
    export
        @gradexpr,
        @hessexpr,
        abs2dual,
        absdual,
        conjdual,
        deparse,
        Dual,
        dual,
        Dual128,
        dual128,
        Dual64,
        dual64,
        dual_show,
        DualPair,
        epsilon,
        grad!,
        grad,
        gradexpr,
        gradfunc!,
        gradfunc,
        hess!,
        hess,
        hessexpr,
        hessfunc!,
        hessfunc,
        integrate,
        isdual,
        isgrad!,
        isgrad,
        ishess!,
        ishess,
        ∇!,
        ∇,
        ∫

    include("utils/maxdiff.jl")

    include("symbolic/symbolic.jl")
    include("symbolic/gradexpr.jl")
    include("symbolic/hessexpr.jl")
    include("symbolic/deparse.jl")

    include("finite/epsilon.jl")
    include("finite/grad.jl")
    include("finite/jacobian.jl")
    include("finite/hess.jl")

    include("automatic/dualnumbers.jl")
    include("automatic/grad.jl")

    include("integrate/simpsons.jl")
    include("integrate/montecarlo.jl")

    include("api/grad.jl")
    include("api/gradfunc.jl")
    include("api/gradexpr.jl")
    include("api/hess.jl")
    include("api/hessfunc.jl")
    include("api/hessexpr.jl")
    include("api/checker.jl")
    include("api/integrate.jl")
    include("api/unicode.jl")
end
