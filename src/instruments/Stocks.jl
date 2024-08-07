export Stock

"""
    Stock

Instrument representing a Stock.
"""
struct Stock{S,C} <: Instrument end

Stock(S::Symbol, C::Type{<:Currency}) = Stock{S,C}()
Stock(S::Symbol, C::Union{Symbol, AbstractString}) = Stock{S,CurrencyType(C)}()

currency(::Stock{S,C}) where {S,C} = CurrencyType(C)