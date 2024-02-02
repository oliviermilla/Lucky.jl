export Cash

# TODO Improvement: have Cash made a singleton
struct Cash{C} <: Instrument end

@inline Cash(C::Symbol) = Cash{Units.Currency{C}}()
@inline Cash(s::String) = Cash(Symbol(s))

import Lucky.Units as Units
Units.currency(s::Cash{C}) where {C} = C
Units.currency(::Type{Cash{C}}) where {C} = C