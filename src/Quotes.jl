module Quotes

export AbstractQuote, NumberQuote, OhlcQuote
export Quote
export currency, timestamp

using Lucky.Instruments
using Lucky.Ohlcs
import Lucky.Units as Units

using Dates

abstract type AbstractQuote end

struct NumberQuote{I,Q,D} <: AbstractQuote
    instrument::I
    price::Q
    timestamp::D
end

struct OhlcQuote{I} <: AbstractQuote
    instrument::I
    ohlc::Ohlc
end

# Interfaces
Quote(instrument::Instrument, price::Q, stamp::D) where {Q<:Number,D<:Dates.AbstractTime} = NumberQuote(instrument, price, stamp)
Quote(instrument::Instrument, ohlc::Q) where {Q<:Ohlc} = OhlcQuote(instrument, ohlc)

Units.currency(q::AbstractQuote) = Units.currency(q.instrument)
timestamp(q::OhlcQuote) = q.ohlc.timestamp
timestamp(q::NumberQuote) = q.timestamp

end