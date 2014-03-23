function autograd{T <: Number}(
    f::Function,
    x::T,
)
    return epsilon(f(Dual(x, one(T))))
end

function autograd!{T <: Real}(
    gr::Vector{T},
    x_d::Vector{Dual{T}},
    f::Function,
    x::Vector{T},
)
    n = length(x)
    for i in 1:n
        x_d[i] = Dual(x[i], zero(T))
    end
    for i in 1:n
        # Why isn't this x[i]
        x_d[i] = Dual(real(x_d[i]), one(T))
        result = f(x_d)
        gr[i] = epsilon(result)
        # Why isn't this x[i]
        x_d[i] = Dual(real(x_d[i]), zero(T))
    end
    return gr
end
