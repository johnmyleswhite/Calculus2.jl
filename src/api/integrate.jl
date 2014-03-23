function integrate(
    f::Function,
    a::Real,
    b::Real;
    method::Symbol = :quadrature,
)
    if method == :quadrature
        res, err = quadgk(f, a, b)
        return res
    elseif method == :simpsons
        return adaptivesimpsons(f, a, b)
    elseif method == :monte_carlo
        return montecarlo(f, a, b)
    else
        throw(
            ArgumentError(
                "method must be :quadrature, :simpsons or :monte_carlo"
            )
        )
    end
end
