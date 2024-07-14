module Currencies

export Currency, CurrencyType
export symbol, currency

using Lucky.Units

"""
    Currency

A Currency is a Unit.
Should not be confused with Cash, which represents a currency in 

Currencies are implemented as a singelton.

# Examples


See also: [`Units`](@ref), [`Cash`](@ref)
"""
struct Currency{S} <: Unit end

Currency(s::Symbol) = Currency{s}()
Currency(s::AbstractString) = Currency(Symbol(s))

# Interfaces

CurrencyType(C::Type{<:Currency}) = C
CurrencyType(s::Symbol) = CurrencyType(Currency{s})
CurrencyType(s::AbstractString) = CurrencyType(Symbol(s))

symbol(::Type{Currency{S}}) where {S} = S
currency(::Type{C}) where {C<:Currency} = C

Base.show(io::IO, ::Type{Currency{S}}) where {S} = print(io, "$(S)")

Base.convert(String, ::Type{C}) where {S,C<:Currency{S}} = String(S)
end