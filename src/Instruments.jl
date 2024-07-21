export Instrument
export InstrumentType

"""
    Instrument

Abstract Instrument type.

An Instrument represents a contract that can be traded.

"""
abstract type Instrument end

InstrumentType(::I) where {I<:Instrument} = I