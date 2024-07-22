export AbstractQuote, Quote
export QuoteType
export quotes
"""
    AbstractQuote

Abstract Quote type.
"""
abstract type AbstractQuote end

function quotes end

currency(q::AbstractQuote) = currency(q.instrument)
QuoteType(I::Type{<:Instrument}, params...) = error("You probably forgot to implement QuoteType(::$(I), $(params...))")
QuoteType(Q::Type{<:AbstractQuote}) = Q

"""
    PriceQuote

Describes a Quote given by a price.    
"""
struct PriceQuote{I,Q,D} <: AbstractQuote
    instrument::I
    price::Q
    timestamp::D
end

"""
    OhlcQuote
    
Describes a Quote given by an Ohlc.
Mostly used for backtesting.
"""
struct OhlcQuote{I,Q} <: AbstractQuote
    instrument::I
    ohlc::Q
end

# Interfaces
"""
    Quote(instrument::Instrument, price::Q, stamp::D)

"""
Quote(instrument::Instrument, price::Q, stamp::D) where {Q<:Number,D<:Dates.AbstractTime} = PriceQuote(instrument, price, stamp)
Quote(instrument::Instrument, ohlc::Q) where {Q<:Ohlc} = OhlcQuote(instrument, ohlc)

QuoteType(I::Type{<:Instrument}, Q::Type{<:Ohlc}) = OhlcQuote{I,Q}
QuoteType(I::Type{<:Instrument}, P::Type{<:Number}=Float64, D::Type{<:Dates.AbstractTime}=Dates.DateTime) = PriceQuote{I,P,D}
QuoteType(i::Instrument, Q::Type{<:Ohlc}) = QuoteType(InstrumentType(i), Q)
QuoteType(i::Instrument, P::Type{<:Number}=Float64, D::Type{<:Dates.AbstractTime}=DateTime) = QuoteType(InstrumentType(i), P, D)

timestamp(q::OhlcQuote) = q.ohlc.timestamp
timestamp(q::PriceQuote) = q.timestamp

TimestampType(::Type{<:OhlcQuote{I,O}}) where {I,O} = TimestampType(O)
TimestampType(::Type{<:PriceQuote{I,P,D}}) where {I,P,D} = D

import Base: +, -, *, /, convert, isless
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

Base.convert(T::Type{<:Number}, x::PriceQuote) = convert(T, x.price)
Base.isless(x::I, y::I) where {I<:PriceQuote} = isless(x.price, y.price)

+(x::I, y::I) where {I<:OhlcQuote} = I(x.instrument, x.ohlc + y.ohlc)
-(x::I, y::I) where {I<:OhlcQuote} = I(x.instrument, x.ohlc - y.ohlc)
*(x::I, y::N) where {I<:OhlcQuote,N<:Number} = I(x.instrument, x.ohlc * y)
/(x::I, y::N) where {I<:OhlcQuote,N<:Number} = I(x.instrument, x.ohlc / y)
Base.convert(T::Type{<:Number}, x::OhlcQuote) = convert(T, x.ohlc)
Base.isless(x::I, y::I) where {I<:OhlcQuote} = isless(x.ohlc, y.ohlc)
