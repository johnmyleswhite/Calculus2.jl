maxdiff(x::Real, y::Real) = abs(x - y)

function maxdiff{T <: Number}(x::Array{T}, y::Array{T})
    m = -Inf
    for i in 1:length(x)
        d = abs(x[i] - y[i])
        if d > m
            m = d
        end
    end
    return m
end
