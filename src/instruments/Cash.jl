export Cash

# TODO Improvement: have Cash made a singleton
struct Cash{C} <: Instrument end

@inline Cash(C::Symbol) = Cash{Currency{C}}()
@inline Cash(s::String) = Cash(Symbol(s))

import Lucky.Units as Units
Units.currency(::Cash{C}) where {C<:Currency} = C