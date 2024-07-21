export Ohlc
export gap, ohlcpart

"""
    Ohlc(open::Float64, high::Float64, low::Float64, close::Float64, timestamp::T) where {T}

Bar data with Open, High, Low, Close and a Timestamp.

"""
struct Ohlc{T<:Dates.AbstractTime}
    open::Float64
    high::Float64
    low::Float64
    close::Float64
    timestamp::T
end

Base.show(io::IO, ohlc::Ohlc{T}) where {T<:Dates.AbstractTime} = show(io, "Ohlc @ $(ohlc.timestamp): O:$(ohlc.open) H:$(ohlc.high) L:$(ohlc.low) C:$(ohlc.close)")

TimestampType(::Type{Ohlc{T}}) where {T} = T
TimestampType(::Ohlc{T}) where {T} = T

@enum OHLC_PART body top bottom
@inline function ohlcpart(ohlc::Ohlc, ::Val{body})
    ohlc.open > ohlc.close && return [ohlc.close, ohlc.open]
    return [ohlc.open, ohlc.close]
end

@inline ohlcpart(ohlc::Ohlc, ::Val{top}) = [max(ohlc.open, ohlc.close), ohlc.high]
@inline ohlcpart(ohlc::Ohlc, ::Val{bottom}) = [ohlc.low, min(ohlc.open, ohlc.close)]
@inline ohlcpart(ohlc::Ohlc, part::OHLC_PART) = ohlcpart(ohlc, Val(part))

@inline function gap(ohlc::Ohlc, ref::Ohlc)
    ohlc.low > ref.high && return (Lucky.up, [ref.high, ohlc.low])
    ohlc.high < ref.low && return (Lucky.down, [ohlc.high, ref.low])
    return nothing
end

# Operators

import Base: +, -, *, /, convert, isless
+(x::I, y::I) where {I<:Ohlc} = I(x.open, max(x.high, y.high), min(x.low, y.low), y.close, max(x.timestamp, y.timestamp))
*(x::I, y::N) where {I<:Ohlc,N<:Number} = I(x.open * y, x.high * y, x.low * y, x.close * y, x.timestamp)
/(x::I, y::N) where {I<:Ohlc,N<:Number} = I(x.open / y, x.high / y, x.low / y, x.close / y, x.timestamp)

# Convert on close
convert(T::Type{<:Number}, x::Ohlc) = convert(T, x.close)

isless(x::I, y::I) where {I<:Ohlc} = isless(x.close, y.close)

# Rocket stuffs
Rocket.scalarness(::Type{<:Ohlc{T}}) where {T} = Rocket.Scalar()