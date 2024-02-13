module Quotes

export AbstractQuote
export Quote, QuoteType
export timestamp
export PriceQuote, OhlcQuote

using Lucky.Instruments
using Lucky.Ohlcs
import Lucky.Units as Units

using Dates

abstract type AbstractQuote end

QuoteType(I::Type{<:Instrument}, params...) = error("You probably forget to implement QuoteType(::$(I), $(params...))")
QuoteType(Q::Type{<:AbstractQuote}) = Q

struct PriceQuote{I,Q,D} <: AbstractQuote
    instrument::I
    price::Q
    timestamp::D
end

struct OhlcQuote{I} <: AbstractQuote
    instrument::I
    ohlc::Ohlc
end

# Interfaces
Quote(instrument::Instrument, price::Q, stamp::D) where {Q<:Number,D<:Dates.AbstractTime} = PriceQuote(instrument, price, stamp)
Quote(instrument::Instrument, ohlc::Q) where {Q<:Ohlc} = OhlcQuote(instrument, ohlc)

QuoteType(I::Type{<:Instrument}, Q::Type{<:Ohlc}) = OhlcQuote{I,Q}
QuoteType(I::Type{<:Instrument}, P::Type{<:Number}=Float64, D::Type{<:TimeType}=DateTime) = PriceQuote{I,P,D}
QuoteType(i::Instrument, Q::Type{<:Ohlc}) = QuoteType(InstrumentType(i), Q)
QuoteType(i::Instrument, P::Type{<:Number}=Float64, D::Type{<:TimeType}=DateTime) = QuoteType(InstrumentType(i), P, D)

Units.currency(q::AbstractQuote) = Units.currency(q.instrument)
timestamp(q::OhlcQuote) = q.ohlc.timestamp
timestamp(q::PriceQuote) = q.timestamp

import Base: +, -, *, /, convert
# https://github.com/JuliaLang/julia/blob/0a8916446b782eae1a09681b2b47c1be26fab7f3/base/missing.jl#L119
for f in (:(+), :(-)) #, :(*), :(/), :(^), :(mod), :(rem))
    @eval begin
        ($f)(::Missing, ::AbstractQuote) = missing
        ($f)(::AbstractQuote, ::Missing) = missing
    end
end

+(x::I, y::I) where {I<:PriceQuote} = I(x.instrument, x.price + y.price, max(timestamp(x), timestamp(y)))
-(x::I, y::I) where {I<:PriceQuote} = I(x.instrument, x.price - y.price, max(timestamp(x), timestamp(y)))
*(x::I, y::N) where {I<:PriceQuote,N<:Number} = I(x.instrument, x.price * y, timestamp(x))
/(x::I, y::N) where {I<:PriceQuote,N<:Number} = I(x.instrument, x.price / y, timestamp(x))
convert(T::Type{<:Number}, x::PriceQuote) = convert(T, x.price)

+(x::I, y::I) where {I<:OhlcQuote} = I(x.instrument, x.ohlc + y.ohlc)
-(x::I, y::I) where {I<:OhlcQuote} = I(x.instrument, x.ohlc - y.ohlc)
*(x::I, y::N) where {I<:OhlcQuote,N<:Number} = I(x.instrument, x.ohlc * y)
/(x::I, y::N) where {I<:OhlcQuote,N<:Number} = I(x.instrument, x.ohlc / y)
convert(T::Type{<:Number}, x::OhlcQuote) = convert(T, x.ohlc)

end