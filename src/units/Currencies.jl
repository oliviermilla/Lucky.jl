export Unit, Currency
export symbol, currency

using Lucky.Units

struct Currency{S} <: Unit end

Currency(S::Symbol) = Currency{S}()
Currency(S::AbstractString) = Currency{Symbol(S)}()

# Interface
symbol(::Type{Currency{S}}) where {S} = S
currency(::Type{C}) where {C<:Currency} = C

Base.show(io::IO, ::Type{Currency{S}}) where {S} = print(io, "$(S)")