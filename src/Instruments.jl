module Instruments

export Instrument, Cash

using Lucky.Units

abstract type Instrument end

struct Cash{C<:Currency} <: Instrument
end
@inline Cash(C::Symbol) = Cash{Currency{C}}()
@inline Cash(s::String) = Cash(Symbol(s))

end