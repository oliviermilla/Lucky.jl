module Indicators

export AbstractIndicator, IterableIndicator, IndicatorType
export RollingIndicator, EMAIndicator, SMAIndicator

using Lucky.Quotes

abstract type AbstractIndicator end

IndicatorType(T::Type{<:AbstractIndicator}, params...) = error("You probably forgot to implement IndicatorType(::$(T), $(params...))")
IndicatorType(::I) where {I<:AbstractIndicator} = I

Base.:+(x::I, y::I) where {I<:AbstractIndicator} = I(x.value + y.value)
Base.:-(x::I, y::I) where {I<:AbstractIndicator} = I(x.value - y.value)
Base.isless(x::I, y::I) where {I<:AbstractIndicator} = isless(x.value, y.value)

abstract type ValueIndicator{V} <: AbstractIndicator end
Base.isless(x::ValueIndicator{V1}, y::ValueIndicator{V2}) where {V1,V2} = isless(x.value, y.value)

IndicatorType(I::Type{<:ValueIndicator}, length::Integer, V::Type{<:Any}) = I{Val(length),Union{Missing,V},V}

abstract type IterableIndicator{V} <: AbstractIndicator end

IndicatorType(I::Type{<:IterableIndicator}, length::Int, V::Type{<:Any}) = I{Val(length),Vector{Union{Missing,V}},V}

# Julia Iterator Interface
Base.iterate(iter::IterableIndicator) = iterate(iter.value)
Base.iterate(iter::IterableIndicator, state) = iterate(iter.value, state)

# Julia Indexing Interface
Base.getindex(x::IterableIndicator, i) = getindex(x.value, i)
Base.setindex!(x::IterableIndicator, v, i) = setindex!(x.value, v, i)
Base.firstindex(x::IterableIndicator) = firstindex(x.value)
Base.lastindex(x::IterableIndicator) = lastindex(x.value)

mutable struct EMAIndicator{LT,U,V} <: ValueIndicator{V}
    length::Integer
    value::U
end

function EMAIndicator(length::Integer, value::V) where {V}
    length > 0 || error("EMAIndicator: $(length) must be positive to calculate a moving average.")
    return EMAIndicator{Val(length),Union{Missing,V},V}(length, value)
end

struct SMAIndicator{LT,U,V} <: ValueIndicator{V}
    value::U
end

function SMAIndicator(length::Integer, value::V) where {V}
    length > 0 || error("SMAIndicator: $(length) must be positive to calculate a moving average.")
    return SMAIndicator{Val(length),Union{Missing,V},V}(value)
end

# mean returns a float when given integers
IndicatorType(::Type{SMAIndicator}, length::Integer, V::Type{<:Integer}) = SMAIndicator{Val(length),Union{Missing,Float64},Float64}

struct RollingIndicator{LT,T,V} <: IterableIndicator{V}
    value::T
end
RollingIndicator(length::Int, value::T) where {V,T<:AbstractArray{V}} = RollingIndicator{Val(length),T,V}(value)

end