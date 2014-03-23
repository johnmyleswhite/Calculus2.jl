function hess{T <: Number}(
    f::Function,
    x::T;
    method::Symbol = :finite,
    direction::Symbol = :central,
) # -> T
    if method == :finite
        return finitehess(f, x, direction)
    else
        throw(ArgumentError("method must be :finite"))
    end
end

function hess!{T <: Number}(
    H::Matrix{T},
    f::Function,
    x::Vector{T};
    method::Symbol = :finite,
    direction::Symbol = :central,
) # -> Matrix{T}
    if method == :finite
        finitehess!(H, f, x, direction)
    else
        throw(ArgumentError("method must be :finite"))
    end
    return H
end

function hess{T <: Number}(
    f::Function,
    x::Vector{T};
    method::Symbol = :finite,
    direction::Symbol = :central,
) # -> Matrix{T}
    n = length(x)
    H = Array(T, n, n)
    hess!(H, f, x, method = method, direction = direction)
    return H
end
