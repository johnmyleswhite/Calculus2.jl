function finitegrad{T <: Number}(
    f::Function,
    x::T,
    direction::Symbol = :central,
)
    if direction == :forward
        ε = @forwardrule(x)
        return (f(x + ε) - f(x)) / ε
    elseif direction == :reverse
        ε = @forwardrule(x)
        return (f(x) - f(x - ε)) / ε
    elseif direction == :central
        ε = @centralrule(x)
        return (f(x + ε) - f(x - ε)) / (ε + ε)
    elseif direction == :complex
        ε = @complexrule(x)
        return imag(f(x + ε * im)) / ε
    else
        throw(
            ArgumentError(
                "direction must be :forward, :reverse, :central or :complex"
            )
        )
    end
end

function finitegrad!{T <: Number}(
    gr::Vector{T},
    f::Function,
    x::Vector{T},
    direction::Symbol = :central,
)
    n = length(x)
    if direction == :forward
        f_x = f(x)
        for i in 1:n
            ε = @forwardrule(x[i])
            x_i = x[i]
            x[i] = x_i + ε
            f_xpdx = f(x)
            gr[i] = (f_xpdx - f_x) / ε
            x[i] = x_i
        end
    elseif direction == :reverse
        f_x = f(x)
        for i in 1:n
            ε = @forwardrule(x[i])
            x_i = x[i]
            x[i] = x_i - ε
            f_xmdx = f(x)
            gr[i] = (f_x - f_xmdx) / ε
            x[i] = x_i
        end
    elseif direction == :central
        for i in 1:n
            ε = @centralrule(x[i])
            x_i = x[i]
            x[i] = x_i + ε
            f_xpdx = f(x)
            x[i] = x_i - ε
            f_xmdx = f(x)
            gr[i] = (f_xpdx - f_xmdx) / (ε + ε)
            x[i] = x_i
        end
    else
        error("direction must be :forward, :reverse or :central")
    end
    return gr
end

function finitegrad!{T <: Number}(
    gr::Vector{T},
    x_c::Vector{Complex{T}},
    f::Function,
    x::Vector{T},
)
    n = length(x)
    for i in 1:n
        x_c[i] = x[i]
    end
    for i in 1:n
        ε = @complexrule(x[i])
        x_c[i] = x[i] + ε * im
        gr[i] = imag(f(x_c)) / ε
        x_c[i] = x[i]
    end
    return gr
end

function finitegrad{T <: Real}(
    f::Function,
    x::Vector{T},
    direction::Symbol = :central,
)
    gr = similar(x)
    if direction == :complex
        x_c = Array(Complex{T}, length(x))
        finitegrad!(gr, x_c, f, x)
    else
        finitegrad!(gr, f, x, direction)
    end
    return gr
end

function taylor_finite_difference(
    f::Function,
    x::Real,
    direction::Symbol = :central,
    h::Real = 10e-4
)
    if direction == :forward
        f_x = f(x)
        d = 2^3 * (2^2 * (f(x + h) - f_x) - (f(x + 2 * h) - f_x))
        d += - (2^2 * (f(x + 2 * h) - f_x) - (f(x + 4 * h) - f_x))
        d /= 3 * 2^2 * h
    elseif direction == :central
        d = 4^5 * (2^3 * (f(x + h) - f(x - h)) - (f(x + 2 * h) - f(x - 2 * h)))
        d -= 2^3 * (f(x + 4 * h) - f(x - 4 * h)) - (f(x + 8 * h) - f(x - 8 * h))
        d /= (4^5 * (2^4 - 2^2) - (2^6 - 2^4)) * h
    else
        throw(ArgumentError("direction must be :forward or :central"))
    end
    return d
end
