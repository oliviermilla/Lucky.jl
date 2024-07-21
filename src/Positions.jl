export Position, PositionType

abstract type AbstractPosition end

PositionType(::P) where {P<:AbstractPosition} = P

struct Position{I<:Instrument,S<:Real,D} <: AbstractPosition
    instrument::I
    size::S
    timestamp::D
end

PositionType(instrument::Instrument, S::Type{<:Real}, Q::Type{<:Any}) = Position{InstrumentType(instrument),S,TimestampType(Q)}
TimestampType(::Position{I,S,D}) where {I,S,D} = D
currency(::Position{I,S}) where {I<:Instrument,S} = currency(I)

