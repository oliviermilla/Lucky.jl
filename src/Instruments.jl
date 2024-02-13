module Instruments

export Instrument, InstrumentType
import Lucky.Units as Units

abstract type Instrument end

# InstrumentType(I::Type{<:Instrument}, params...) = error("You probably forget to implement InstrumentType($(I), $(params...))")
InstrumentType(::I) where{I<:Instrument} = I

currency(i::Instrument) = error("You probably forget to implement currency(::$(typeof(I)))")

include("instruments/Cash.jl")
include("instruments/Stocks.jl")

end