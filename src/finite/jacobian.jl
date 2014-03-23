# TODO: Use a fixed vector, f_x
function finitejacobian!{T <: FloatingPoint}(
    f::Function,
    x::Vector{T},
    f_x::Vector{T},
    J::Array{T},
    direction::Symbol = :central,
)
    m, n = size(J)
    if direction == :forward
        for i = 1:n
            ε = @forwardrule(x[i])
            x_i = x[i]
            x[i] = x_i + ε
            # TODO: Need this to do mutation to be efficient
            f_xplusdx = f(x)
            x[i] = x_i
            J[:, i] = (f_xplusdx - f_x) / ε
        end
    elseif dtype == :central
        for i = 1:n
            ε = @centralrule(x[i])
            x_i = x[i]
            x[i] = x_i + ε
            f_xplusdx = f(x)
            x[i] = x_i - ε
            f_xminusdx = f(x)
            x[i] = x_i
            J[:, i] = (f_xplusdx - f_xminusdx) / (ε + ε)
        end
    else
        error("direction must :forward or :central")
    end
    return
end

function finitejacobian{T <: FloatingPoint}(
    f::Function,
    x::Vector{T},
    direction::Symbol = :central,
)
    f_x = f(x)
    J = zeros(length(f_x), length(x))
    finitejacobian!(f, x, f_x, J, direction)
    return J
end
