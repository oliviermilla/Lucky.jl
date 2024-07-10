module Trades

export AbstractTrade
export Trade

using Lucky.Fills
using Lucky.Instruments
import Lucky.Units as Units

abstract type AbstractTrade <: AbstractFill end

struct Trade{I,S,D} <: AbstractTrade
    instrument::I
    size::S
    timestamp::D
end

Trade(instrument::Instrument, size::Number) = Trade(instrument, size, missing)

Units.currency(t::Trade{I,S,D}) where {I<:Instrument,S,D} = Units.currency(t.instrument)

end