module Trades

export AbstractTrade
export Trade

using Lucky.Fills
using Lucky.Instruments
import Lucky.Units as Units

abstract type AbstractTrade <: AbstractFill end

struct Trade{I,S,D} <: AbstractTrade
    instrument::I
    price::Float64
    size::S
    timestamp::D
end

Trade(instrument::Instrument, price::Float64, size::Number) = Trade(instrument, price, size, missing)

Units.currency(t::Trade{I,S,D}) where {I<:Instrument,S,D} = Units.currency(t.instrument)

end