module Instruments

export Instrument, InstrumentType
import Lucky.Units as Units

abstract type Instrument end

# InstrumentType(I::Type{<:Instrument}, params...) = error("You probably forget to implement InstrumentType($(I), $(params...))")
InstrumentType(::I) where {I<:Instrument} = I

Units.currency(I::Type{<:Instrument}) = error("You probably forgot to implement currency(::$(I)")
Units.currency(i::I) where {I<:Instrument} = error("You probably forgot to implement currency(::$(I)")

include("instruments/Cash.jl")
include("instruments/Stocks.jl")

end