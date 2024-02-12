module Positions

export Position

import Lucky.Instruments as Instruments
import Lucky.Units as Units

struct Position{I<:Instruments.Instrument}
    instrument::I
    size::Real
end

Units.currency(::Position{I}) where {I<:Instruments.Instrument} = Units.currency(I)

end