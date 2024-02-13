module Positions

export Position, PositionType

import Lucky.Instruments as Instruments
import Lucky.Units as Units

abstract type AbstractPosition end

PositionType(::P) where{P<:AbstractPosition} = P

struct Position{I<:Instruments.Instrument,S<:Real} <: AbstractPosition
    instrument::I
    size::S
end

Units.currency(::Position{I,S}) where {I<:Instruments.Instrument,S} = Units.currency(I)

end