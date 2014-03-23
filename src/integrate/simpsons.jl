function adaptivesimpsons_inner(
    f::Function,
    a::Real,
    b::Real,
    ε::Real,
    S::Real,
    fa::Real,
    fb::Real,
    fc::Real,
    bottom::Integer,
)
    c = (a + b) / 2
    h = b - a
    d = (a + c) / 2
    g = (c + b) / 2
    fd = f(d)
    fe = f(g)
    Sleft = (h / 12) * (fa + 4 * fd + fc)
    Sright = (h / 12) * (fc + 4 * fe + fb)
    S2 = Sleft + Sright
    if bottom <= 0 || abs(S2 - S) <= 15 * ε
        return S2 + (S2 - S) / 15
    end
    res1 = adaptivesimpsons_inner(
        f,
        a,
        c,
        ε / 2,
        Sleft,
        fa,
        fc,
        fd,
        bottom - 1
    )
    res2 = adaptivesimpsons_inner(
        f,
        c,
        b,
        ε / 2,
        Sright,
        fc,
        fb,
        fe,
        bottom - 1
    )
    return res1 + res2
end

function adaptivesimpsons(
    f::Function,
    a::Real,
    b::Real,
    accuracy::Real = 10e-10,
    max_iterations::Integer = 50,
)
    c = (a + b) / 2
    h = b - a
    fa = f(a)
    fb = f(b)
    fc = f(c)
    S = (h / 6) * (fa + 4 * fc + fb)
    return adaptivesimpsons_inner(
        f,
        a,
        b,
        accuracy,
        S,
        fa,
        fb,
        fc,
        max_iterations
    )
end
