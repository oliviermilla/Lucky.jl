export Stock

struct Stock{S,C} <: Instrument end

Stock(S::Symbol, C::Type{<:Units.Currency}) = Stock{S,C}()
Stock(S::Symbol, C::Union{Symbol, AbstractString}) = Stock{S,Units.CurrencyType(C)}()

Units.currency(s::Stock{S,C}) where {S,C} = Units.CurrencyType(C)