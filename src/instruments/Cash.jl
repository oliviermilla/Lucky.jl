export Cash

struct Cash{C<:Currency} <: Instrument end

@inline Cash(C::Symbol) = Cash{Currency{C}}()
@inline Cash(s::String) = Cash(Symbol(s))