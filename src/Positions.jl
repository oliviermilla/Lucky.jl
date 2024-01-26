module Positions

export Position

using Lucky.Instruments

struct Position{I<:Instrument}
    a::Float32
end

end