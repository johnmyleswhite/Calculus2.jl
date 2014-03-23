function grad{T <: Number}(
    f::Function,
    x::T;
    method::Symbol = :finite,
    direction::Symbol = :central,
) # -> T
    if method == :finite
        return finitegrad(f, x, direction)
    elseif method == :ad
        return autograd(f, x)
    else
        throw(ArgumentError("method must be :finite or :ad"))
    end
end

function grad!{T <: Number}(
    gr::Vector{T},
    f::Function,
    x::Vector{T};
    method::Symbol = :finite,
    direction::Symbol = :central,
) # -> Vector{T}
    if method == :finite
        finitegrad!(gr, f, x, direction)
    elseif method == :ad
        # TODO: Raise a warning here that memory is being allocated?
        autograd!(gr, Array(Dual{T}, length(x)), f, x)
    else
        throw(ArgumentError("method must be :finite or :ad"))
    end
    return gr
end

function grad!{T <: Number}(
    gr::Vector{T},
    x_d::Vector{Dual{T}},
    f::Function,
    x::Vector{T};
    method::Symbol = :finite,
    direction::Symbol = :central,
) # -> Vector{T}
    if method == :finite
        finitegrad!(gr, f, x, direction)
    elseif method == :ad
        autograd!(gr, x_d, f, x)
    else
        throw(ArgumentError("method must be :finite or :ad"))
    end
    return gr
end

function grad{T <: Number}(
    f::Function,
    x::Vector{T};
    method::Symbol = :finite,
    direction::Symbol = :central,
) # -> Vector{T}
    n = length(x)
    gr = Array(T, n)
    if method == :ad
        x_d = Array(Dual{T}, n)
        grad!(gr, x_d, f, x, method = method, direction = direction)
    else
        grad!(gr, f, x, method = method, direction = direction)
    end
    return gr
end
