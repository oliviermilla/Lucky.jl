module Indicators

export AbstractIndicator, IterableIndicator, ValueIndicator, IndicatorType

using Lucky.Quotes

abstract type AbstractIndicator end

value(i::AbstractIndicator) = i.value

IndicatorType(T::Type{<:AbstractIndicator}, params...) = error("You probably forgot to implement IndicatorType(::$(T), $(params...))")
IndicatorType(::I) where {I<:AbstractIndicator} = I

Base.:+(x::I, y::I) where {I<:AbstractIndicator} = I(x.value + y.value)
Base.:-(x::I, y::I) where {I<:AbstractIndicator} = I(x.value - y.value)
Base.isless(x::I, y::I) where {I<:AbstractIndicator} = isless(x.value, y.value)

abstract type ValueIndicator{V} <: AbstractIndicator end
Base.isless(x::ValueIndicator{V1}, y::ValueIndicator{V2}) where {V1,V2} = isless(x.value, y.value)

IndicatorType(I::Type{<:ValueIndicator}, V::Type{<:Any}) = I{Union{Missing,V},V}
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

include("indicators/DrawdownIndicators.jl")
include("indicators/EMAIndicators.jl")
include("indicators/HighWaterMarkIndicators.jl")
include("indicators/RollingIndicators.jl")
include("indicators/SMAIndicators.jl")

end