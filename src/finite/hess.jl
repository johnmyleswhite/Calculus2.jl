function finitehess{T <: Number}(
    f::Function,
    x::T,
    direction::Symbol = :central,
)
    ε = @hessianrule(x)
    return (f(x + ε) - 2 * f(x) + f(x - ε)) / (ε * ε)
end

function finitehess!{T <: Number}(
    H::Array{T},
    f::Function,
    x::Vector{T},
    direction::Symbol = :central,
)
    n = length(x)
    ε = nan(T)
    # TODO: Remove all these copies
    xpp, xpm, xmp, xmm = copy(x), copy(x), copy(x), copy(x)
    f_x = f(x)
    for i in 1:n
        x_i = x[i]
        ε = @hessianrule(x[i])
        xpp[i], xmm[i] = x_i + ε, x_i - ε
        H[i, i] = (f(xpp) - 2 * f_x + f(xmm)) / (ε * ε)
        ε_i = @centralrule(x[i])
        xp = x_i + ε_i
        xm = x_i - ε_i
        xpp[i], xpm[i], xmp[i], xmm[i] = xp, xp, xm, xm
        for j in (i + 1):n
            x_j = x[j]
            ε_j = @centralrule(x[j])
            xp = x_j + ε_j
            xm = x_j - ε_j
            xpp[j], xpm[j], xmp[j], xmm[j] = xp, xm, xp, xm
            H[i, j] = (f(xpp) - f(xpm) - f(xmp) + f(xmm)) / (4 * ε_i * ε_j)
            xpp[j], xpm[j], xmp[j], xmm[j] = x_j, x_j, x_j, x_j
        end
        xpp[i], xpm[i], xmp[i], xmm[i] = x_i, x_i, x_i, x_i
    end
    Base.LinAlg.copytri!(H, 'U')
    return H
end

function finitehess{T <: Number}(
    f::Function,
    x::Vector{T},
    direction::Symbol = :central
)
    n = length(x)
    H = Array(T, n, n)
    finitehess!(f, x, H, direction)
    return H
end

function taylor_finite_difference_hessian(
    f::Function,
    x::Real,
    h::Real,
)
    f_x = f(x)
    d = 4^6 * (2^4 * (f(x + h) + f(x - h) - 2 * f_x) - (f(x + 2 * h) + f(x - 2 * h) - 2 * f_x))
    d += - (2^4 * (f(x + 4 * h) + f(x - 4 * h) - 2 * f_x) - (f(x + 8 * h) + f(x - 8 * h) - 2 * f_x))
    return d / (3 * 2^6 * (2^8 - 1) * h^2)
end
