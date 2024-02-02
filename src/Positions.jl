module Positions

export Position

import Lucky.Instruments as Instruments
import Lucky.Units as Units

struct Position{I<:Instruments.Instrument}
    amount::Float64
end
Position(::Type{I}, amt) where {I<:Instruments.Instrument} = Position{I}(amt)
Instruments.instrument(::Position{I}) where {I<:Instruments.Instrument} = Instruments.instrument(I)

Units.currency(::Position{I}) where {I<:Instruments.Instrument} = Units.currency(I)

end