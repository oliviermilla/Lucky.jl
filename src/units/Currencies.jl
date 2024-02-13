export Currency, CurrencyType
export symbol, currency

using Lucky.Units

struct Currency{S} <: Unit end

# Constructors
Currency(s::Symbol) = Currency{s}()
Currency(s::AbstractString) = Currency(Symbol(s))

# Interface
CurrencyType(C::Type{<:Currency}) = C
CurrencyType(s::Symbol) = CurrencyType(Currency{s})
CurrencyType(s::AbstractString) = CurrencyType(Symbol(s))

symbol(::Type{Currency{S}}) where {S} = S
currency(::Type{C}) where {C<:Currency} = C

Base.show(io::IO, ::Type{Currency{S}}) where {S} = print(io, "$(S)")