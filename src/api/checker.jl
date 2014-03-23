function isgrad{T <: Number}(
    g::Function,
    f::Function,
    x::T;
    tol::Real = @centralrule(x),
)
    return maxdiff(g(x), grad(f, x)) <= tol
end

function isgrad!{T <: Number}(
    g!::Function,
    f::Function,
    x::Vector{T};
    tol::Real = @centralrule(maximum(abs(x))),
)
    n = length(x)
    gr = Array(T, n)
    g!(gr, x)
    return maxdiff(gr, grad(f, x)) <= tol
end

function isgrad{T <: Number}(
    g::Function,
    f::Function,
    x::Vector{T};
    tol::Real =  @centralrule(maximum(abs(x))),
)
    return maxdiff(g(x), grad(f, x)) <= tol
end

function ishess{T <: Number}(
    h::Function,
    f::Function,
    x::T;
    tol::Real = @hessianrule(x),
)
    return maxdiff(h(x), hess(f, x)) <= tol
end

function ishess!{T <: Number}(
    h!::Function,
    f::Function,
    x::Vector{T};
    tol::Real = @hessianrule(maximum(abs(x))),
)
    n = length(x)
    H = Array(T, n, n)
    h!(H, x)
    return maxdiff(H, hess(f, x)) <= tol
end

function ishess{T <: Number}(
    h::Function,
    f::Function,
    x::Vector{T};
    tol::Real = @hessianrule(maximum(abs(x))),
)
    return maxdiff(h(x), hess(f, x)) <= tol
end
