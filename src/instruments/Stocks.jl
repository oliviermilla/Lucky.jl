export Stock

struct Stock{S,C} <: Instrument end

Stock(S::Symbol, C::Type{<:Units.Currency}) = Stock{S,C}()
Stock(S::Symbol, C::Symbol) = Stock{S,Units.Currency{C}}()

Units.currency(s::Stock{S,C}) where {S,C} = C