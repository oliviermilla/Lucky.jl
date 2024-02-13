module Indicators

export AbstractIndicator, IndicatorType
export SMAIndicator

using Lucky.Quotes

abstract type AbstractIndicator end

# value(ind::T) where{T<:AbstractIndicator} = ind.value # error("You probably forgot to implement value() for $(T)!")
IndicatorType(T::Type{<:AbstractIndicator}, params...) = error("You probably forgot to implement IndicatorType(::$(T), $(params...))")
IndicatorType(t::I) where {I<:AbstractIndicator} = I

Base.:+(x::I, y::I) where {I<:AbstractIndicator} = I(x.value + y.value)
Base.:-(x::I, y::I) where {I<:AbstractIndicator} = I(x.value - y.value)
Base.isless(x::I, y::I) where {I<:AbstractIndicator} = isless(x.value, y.value)

struct SMAIndicator{LT,V} <: AbstractIndicator
    value::V
    function SMAIndicator(length::Integer, value::T) where {T}
        length > 0 || error("SMAIndicator: $(length) must be positive to calculate a moving average.")
        return new{Val(length),Union{Missing,T}}(value)
    end
end

IndicatorType(::Type{SMAIndicator}, length::Integer, Q::Type{<:AbstractQuote}) = SMAIndicator{Val(length),Union{Missing,Q}}

Base.isless(x::SMAIndicator{I}, y::SMAIndicator{J}) where {I,J} = isless(x.value, y.value)

end