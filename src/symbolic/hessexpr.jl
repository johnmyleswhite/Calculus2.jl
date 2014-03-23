function hessexpr(ex_f::Expr, xs::Symbol)
    ex_g = gradexpr(ex_f, xs)
    ex_h = gradexpr(ex_g, xs)
    return ex_h
end

function hessexpr(ex_f::Expr, xs::Vector{Symbol})
    n = length(xs)
    exs_g = gradexpr(ex_f, xs)
    exs_h = Array(Any, n, n)
    for i in 1:n
        for j in 1:n
            exs_h[i, j] = gradexpr(exs_g[i], xs[j])
        end
    end
    return exs_h
end
