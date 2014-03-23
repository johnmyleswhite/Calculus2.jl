function hessfunc{T <: Number}(
    f::Function,
    x::T;
    method::Symbol = :finite,
    direction::Symbol = :central,
) # -> Function
    if method == :finite
        function h(x::T)
            return finitehess(f, x, direction)
        end
    else
        throw(ArgumentError("method must be :finite"))
    end
    return h
end

function hessfunc!{T <: Number}(
    f::Function,
    x::Vector{T};
    method::Symbol = :finite,
    direction::Symbol = :central,
) # -> Function
    if method == :finite
        function h!(H::Matrix{T}, x::Vector{T})
            return finitehess!(H, f, x, direction)
        end
    else
        throw(ArgumentError("method must be :finite"))
    end
    return h!
end

function hessfunc{T <: Number}(
    f::Function,
    x::Vector{T};
    method::Symbol = :finite,
    direction::Symbol = :central,
) # -> Function
    if method == :finite
        function h(x::Vector{T})
            n = length(x)
            H = Array(T, n, n)
            finitehess!(H, f, x, direction)
            return H
        end
    else
        throw(ArgumentError("method must be :finite"))
    end
    return h
end
