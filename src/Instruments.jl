module Instruments

export Instrument

using Lucky.Units

abstract type Instrument end

include("instruments/Cash.jl")

end