# importall Base

immutable Dual{T <: Real} <: Number
    re::T
    du::T
end

Dual(x::Real, y::Real) = Dual(promote(x, y)...)

Dual(x::Real) = Dual(x, zero(x))

typealias Dual128 Dual{Float64}
typealias Dual64 Dual{Float32}
typealias DualPair Dual

Base.real(z::Dual) = z.re
epsilon(z::Dual) = z.du

Base.eps(z::Dual) = eps(real(z))
Base.eps{T}(::Type{Dual{T}}) = eps(T)
Base.one(z::Dual) = dual(one(real(z)))
Base.one{T}(::Type{Dual{T}}) = dual(one(T))
Base.inf{T}(::Type{Dual{T}}) = dual(inf(T))
Base.nan{T}(::Type{Dual{T}}) = nan(T)
Base.isnan(z::Dual) = isnan(real(z))

function Base.convert{T<:Real}(::Type{Dual{T}}, x::Real)
    return Dual{T}(convert(T, x), convert(T, 0))
end
Base.convert{T<:Real}(::Type{Dual{T}}, z::Dual{T}) = z
function Base.convert{T <: Real}(::Type{Dual{T}}, z::Dual)
    return Dual{T}(convert(T, real(z)), convert(T, epsilon(z)))
end

function Base.convert{T <: Real}(::Type{T}, z::Dual)
    if epsilon(z) == zero(T)
        return convert(T, real(z))
    else
        throw(InexactError())
    end
end

function Base.promote_rule{T<:Real, S<:Real}(::Type{Dual{T}}, ::Type{Dual{S}})
    return Dual{promote_type(T, S)}
end

# these promotion rules shouldn't be used for scalar operations -- they're slow
Base.promote_rule{T<:Real}(::Type{Dual{T}}, ::Type{T}) = Dual{T}
function Base.promote_rule{T<:Real, S<:Real}(::Type{Dual{T}}, ::Type{S})
  Dual{promote_type(T, S)}
end

dual(x, y) = Dual(x, y)
dual(x) = Dual(x)

Base.@vectorize_1arg Real dual

dual128(x::Float64, y::Float64) = Dual{Float64}(x, y)
dual128(x::Real, y::Real) = dual128(float64(x), float64(y))
dual128(z) = dual128(real(z), epsilon(z))
dual64(x::Float32, y::Float32) = Dual{Float32}(x, y)
dual64(x::Real, y::Real) = dual64(float32(x), float32(y))
dual64(z) = dual64(real(z), epsilon(z))

isdual(x::Dual) = true
isdual(x::Number) = false

Base.real_valued{T<:Real}(z::Dual{T}) = epsilon(z) == 0
Base.integer_valued(z::Dual) = real_valued(z) && integer_valued(real(z))

Base.isfinite(z::Dual) = isfinite(real(z))
Base.reim(z::Dual) = (real(z), epsilon(z))

function dual_show(io::IO, z::Dual, compact::Bool)
    x, y = reim(z)
    if isnan(x) || isfinite(y)
        compact ? showcompact(io,x) : show(io,x)
        if signbit(y)==1 && !isnan(y)
            y = -y
            print(io, compact ? "-" : " - ")
        else
            print(io, compact ? "+" : " + ")
        end
        compact ? showcompact(io, y) : show(io, y)
        if !(isa(y,Integer) || isa(y,Rational) ||
             isa(y,FloatingPoint) && isfinite(y))
            print(io, "*")
        end
        print(io, "du")
    else
        print(io, "dual(", x, ",", y, ")")
    end
end
Base.show(io::IO, z::Dual) = dual_show(io, z, false)
Base.showcompact(io::IO, z::Dual) = dual_show(io, z, true)

function Base.read{T<:Real}(s::IO, ::Type{Dual{T}})
    x = read(s, T)
    y = read(s, T)
    Dual{T}(x, y)
end
function Base.write(s::IO, z::Dual)
    write(s, real(z))
    write(s, epsilon(z))
end

## Generic functions of dual numbers ##

Base.convert(::Type{Dual}, z::Dual) = z
Base.convert(::Type{Dual}, x::Real) = dual(x)

Base.(:(==))(z::Dual, w::Dual) = real(z) == real(w) && epsilon(z) == epsilon(w)
# ==(z::Dual, x::Real) = real_valued(z) && real(z) == x
# ==(x::Real, z::Dual) = real_valued(z) && real(z) == x

function Base.isequal(z::Dual, w::Dual)
    return isequal(real(z),real(w)) && isequal(epsilon(z), epsilon(w))
end
Base.isequal(z::Dual, x::Real) = real_valued(z) && isequal(real(z), x)
Base.isequal(x::Real, z::Dual) = real_valued(z) && isequal(real(z), x)

Base.isless(z::Dual,w::Dual) = real(z) < real(w)
Base.isless(z::Number,w::Dual) = z < real(w)
Base.isless(z::Dual,w::Number) = real(z) < w

function Base.hash(z::Dual)
    x = hash(real(z));
    return real_valued(z) ? x : bitmix(x, hash(epsilon(z)))
end

# we don't support Dual{Complex}, so conj is a noop
Base.conj(z::Dual) = z
Base.abs(z::Dual)  = (real(z) >= 0) ? z : -z
Base.abs2(z::Dual) = z*z

# algebraic definitions
conjdual(z::Dual) = Dual(real(z),-epsilon(z))
absdual(z::Dual) = abs(real(z))
abs2dual(z::Dual) = abs2(real(z))

Base.(:(+))(z::Dual, w::Dual) = dual(real(z)+real(w), epsilon(z)+epsilon(w))
Base.(:(+))(z::Number, w::Dual) = dual(z+real(w), epsilon(w))
Base.(:(+))(z::Dual, w::Number) = dual(real(z)+w, epsilon(z))

Base.(:(-))(z::Dual) = dual(-real(z), -epsilon(z))
Base.(:(-))(z::Dual, w::Dual) = dual(real(z)-real(w), epsilon(z)-epsilon(w))
Base.(:(-))(z::Number, w::Dual) = dual(z-real(w), -epsilon(w))
Base.(:(-))(z::Dual, w::Number) = dual(real(z)-w, epsilon(z))

# avoid ambiguous definition with Bool * Number
function Base.(:(*))(x::Bool, z::Dual)
    return ifelse(x, z, ifelse(signbit(real(z)) == 0, zero(z), -zero(z)))
end
Base.(:(*))(x::Dual, z::Bool) = z * x

function Base.(:(*))(z::Dual, w::Dual)
    return dual(real(z) * real(w), epsilon(z) * real(w) + real(z) * epsilon(w))
end
Base.(:(*))(x::Real, z::Dual) = dual(x * real(z), x * epsilon(z))
Base.(:(*))(z::Dual, x::Real) = dual(x * real(z), x * epsilon(z))

Base.(:(/))(z::Real, w::Dual) = dual(z / real(w), -z * epsilon(w) / real(w)^2)
Base.(:(/))(z::Dual, x::Real) = dual(real(z) / x, epsilon(z) / x)
function Base.(:(/))(z::Dual, w::Dual)
    return dual(
        real(z) / real(w),
        (epsilon(z) * real(w) - real(z) * epsilon(w)) / (real(w) * real(w))
    )
end

function Base.(:(^))(z::Dual, w::Dual)
    re = real(z)^real(w)
    du = epsilon(z) * real(w) * (real(z)^(real(w) - 1))
    du += epsilon(w) * (real(z)^real(w)) * log(real(z))
    return dual(re, du)
end

# these two definitions are needed to fix ambiguity warnings
function Base.(:(^))(z::Dual, n::Integer)
    return dual(real(z)^n, epsilon(z) * n * real(z)^(n - 1))
end
function Base.(:(^))(z::Dual, n::Rational)
    return dual(real(z)^n, epsilon(z) * n * real(z)^(n - 1))
end
function Base.(:(^))(z::Dual, n::Real)
    return dual(real(z)^n, epsilon(z) * n * real(z)^(n - 1))
end

for (funsym, exp) in derivative_rules
    @eval function (Base.$funsym)(z::Dual)
        xp = epsilon(z)
        x = real(z)
        Dual($(funsym)(x),$exp)
    end
end
