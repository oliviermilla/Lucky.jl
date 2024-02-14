module Positions

export Position, PositionType

#import Lucky.Instruments as Instruments
using Lucky.Instruments
using Lucky.Quotes
import Lucky.Units as Units

abstract type AbstractPosition end

PositionType(::P) where {P<:AbstractPosition} = P

struct Position{I<:Instrument,S<:Real,D} <: AbstractPosition
    instrument::I
    size::S
    timestamp::D
end

PositionType(instrument::Instrument, S::Type{<:Real}, Q::Type{<:Any}) = Position{InstrumentType(instrument),S,Units.TimestampType(Q)}
Units.TimestampType(::Position{I,S,D}) where {I,S,D} = D
Units.currency(::Position{I,S}) where {I<:Instrument,S} = Units.currency(I)

end