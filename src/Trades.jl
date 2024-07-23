export AbstractTrade
export Trade

"""
    AbstractTrade

Abstract Trade type.

A Trade is an actual exchange of a given Instrument.

"""
abstract type AbstractTrade <: AbstractFill end

struct Trade{I,S,D} <: AbstractTrade
    instrument::I
    price::Float64
    size::S
    timestamp::D
end

struct OhlcTrade{I,Q} <: AbstractTrade
    instrument::I
    ohlc::Q
end

Trade(instrument::Instrument, price::Float64, size::Number) = Trade(instrument, price, size, missing)

currency(t::Trade{I,S,D}) where {I<:Instrument,S,D} = currency(t.instrument)