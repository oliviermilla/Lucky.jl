module Units

export Unit, Currency
export symbol, currency

abstract type Unit end

struct Currency{S} <: Unit end

Currency(S::Symbol) = Currency{S}()
Currency(S::AbstractString) = Currency{Symbol(S)}()

symbol(::Type{Currency{S}}) where {S} = S
currency(::Type{C}) where {C<:Currency} = C

Base.show(io::IO, c::Currency{S}) where {S} = print(io, "$(S)")

end