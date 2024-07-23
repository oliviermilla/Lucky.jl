export Currency
export symbol, currency
export CurrencyType

"""
    Currency

A Currency is type of Unit.
It should not be confused with Cash, which represents the amount of a certain Currency.

Currencies are implemented as a singelton.

# Examples

```jldoctest
c = Currency(:USD)

# output

USD()
```

See also: [`Unit`](@ref units)
"""
struct Currency{S} <: Unit end

Currency(s::Symbol) = Currency{s}()
Currency(s::AbstractString) = Currency(Symbol(s))

# Interfaces

CurrencyType(C::Type{<:Currency}) = C
CurrencyType(s::Symbol) = CurrencyType(Currency{s})
CurrencyType(s::AbstractString) = CurrencyType(Symbol(s))

symbol(::Type{Currency{S}}) where {S} = S    

"""
    currency

    Returns the currency of the object.    
"""
currency(o::Any) = error("You probably forgot to implement currency(::$(o)")
currency(::Type{C}) where {C<:Currency} = C

Base.show(io::IO, ::Type{Currency{S}}) where {S} = print(io, "$(S)")

Base.convert(::Type{String}, ::Type{C}) where {S,C<:Currency{S}} = String(S)