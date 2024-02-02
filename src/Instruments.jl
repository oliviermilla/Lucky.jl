module Instruments

export Instrument
export instrument

import Lucky.Units as Units

abstract type Instrument end

instrument(::Type{I}) where {I<:Instrument} = I

include("instruments/Cash.jl")
include("instruments/Stocks.jl")

end