export Cash

# TODO Improvement: have Cash made a singleton

"""
    Cash

Instrument representing Cash.
"""
struct Cash{C} <: Instrument end

@inline Cash(C::Symbol) = Cash{Currency{C}}()
@inline Cash(s::String) = Cash(Symbol(s))

currency(::Cash{C}) where {C<:Currency} = C
currency(::Type{Cash{C}}) where {C<:Currency} = C