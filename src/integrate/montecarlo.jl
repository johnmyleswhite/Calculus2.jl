function montecarlo(
    f::Function,
    a::Real,
    b::Real,
    iterations::Integer = 10_000,
)
    width = (b - a)
    estimate = 0.0
    for i in 1:iterations
        x = width * rand() + a
        estimate += f(x) * width
    end
    return estimate / iterations
end
