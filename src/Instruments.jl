"""
    Instrument

Abstract Instrument type.

An Instrument represents a contract that can be traded.

"""
abstract type Instrument end

InstrumentType(::I) where {I<:Instrument} = I

currency(I::Type{<:Instrument}) = error("You probably forgot to implement currency(::$(I)")
currency(i::I) where {I<:Instrument} = error("You probably forgot to implement currency(::$(I)")