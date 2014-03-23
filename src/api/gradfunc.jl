function gradfunc{T <: Number}(
    f::Function,
    x::T;
    method::Symbol = :finite,
    direction::Symbol = :central,
) # -> Function
    if method == :finite
        function g(x::T)
            return finitegrad(f, x, direction)
        end
    elseif method == :ad
        function g(x::T)
            return autograd(f, x)
        end
    else
        throw(ArgumentError("method must be :finite or :ad"))
    end
    return g
end


function gradfunc!{T <: Number}(
    f::Function,
    x::Vector{T};
    method::Symbol = :finite,
    direction::Symbol = :central,
) # -> Function
    if method == :finite
        function g!(gr::Vector{T}, x::Vector{T})
            return finitegrad!(gr, f, x, direction)
        end
    elseif method == :ad
        x_d = Array(Dual{T}, length(x))
        function g!(gr::Vector{T}, x::Vector{T})
            return autograd!(gr, x_d, f, x)
        end
    else
        throw(ArgumentError("method must be :finite or :ad"))
    end
    return g!
end

function gradfunc{T <: Number}(
    f::Function,
    x::Vector{T};
    method::Symbol = :finite,
    direction::Symbol = :central,
) # -> Function
    if method == :finite
        function g(x::Vector{T})
            gr = similar(x)
            finitegrad!(gr, f, x, direction)
            return gr
        end
    elseif method == :ad
        x_d = Array(Dual{T}, length(x))
        function g(x::Vector{T})
            gr = similar(x)
            autograd!(gr, x_d, f, x)
            return gr
        end
    else
        throw(ArgumentError("method must be :finite or :ad"))
    end
    return g
end
