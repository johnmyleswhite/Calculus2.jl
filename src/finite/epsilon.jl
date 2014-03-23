macro forwardrule(x)
    :(sqrt(eps(eltype($x))) * max(one(eltype($x)), abs($x)))
end

macro centralrule(x)
    :(cbrt(eps(eltype($x))) * max(one(eltype($x)), abs($x)))
end

macro hessianrule(x)
    :(eps(eltype($x))^(1//4) * max(one(eltype($x)), abs($x)))
end

macro complexrule(x)
    :(eps($x))
end
