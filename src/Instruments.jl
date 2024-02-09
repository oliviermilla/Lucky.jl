module Instruments

export Instrument

import Lucky.Units as Units

abstract type Instrument end

include("instruments/Cash.jl")
include("instruments/Stocks.jl")

end