module Indicators

export AbstractIndicator, IterableIndicator, IndicatorType
export RollingIndicator, SMAIndicator

using Lucky.Quotes

abstract type AbstractIndicator end
abstract type IterableIndicator{Q} <: AbstractIndicator end

IndicatorType(T::Type{<:AbstractIndicator}, params...) = error("You probably forgot to implement IndicatorType(::$(T), $(params...))")
IndicatorType(t::I) where {I<:AbstractIndicator} = I

# Julia Iterator Interface
Base.iterate(iter::IterableIndicator) = iterate(iter.value)
Base.iterate(iter::IterableIndicator, state) = iterate(iter.value, state)

Base.:+(x::I, y::I) where {I<:AbstractIndicator} = I(x.value + y.value)
Base.:-(x::I, y::I) where {I<:AbstractIndicator} = I(x.value - y.value)
Base.isless(x::I, y::I) where {I<:AbstractIndicator} = isless(x.value, y.value)

struct SMAIndicator{LT,V} <: AbstractIndicator
    value::V
end

function SMAIndicator(length::Integer, value::V) where {V}
    length > 0 || error("SMAIndicator: $(length) must be positive to calculate a moving average.")
    return SMAIndicator{Val(length),Union{Missing,V}}(value)
end

IndicatorType(::Type{SMAIndicator}, length::Integer, Q::Type{<:Any}) = SMAIndicator{Val(length),Union{Missing, Q}}
IndicatorType(::Type{SMAIndicator}, length::Integer, Q::Type{<:AbstractQuote}) = SMAIndicator{Val(length),Union{Missing, Q}}
IndicatorType(::Type{SMAIndicator}, length::Integer, Q::Type{<:Integer}) = SMAIndicator{Val(length),Union{Missing, Float64}}

Base.isless(x::SMAIndicator{I}, y::SMAIndicator{J}) where {I,J} = isless(x.value, y.value)

struct RollingIndicator{LT,V,Q} <: IterableIndicator{Q}
    value::V
end
RollingIndicator(length::Int, value::AbstractArray{T}) where {T} = RollingIndicator{Val(length),V,T}(value)
IndicatorType(::Type{RollingIndicator}, length::Int, Q::Type{<:Any}) = RollingIndicator{Val(length), Vector{Union{Missing, Q}}, Q}
end