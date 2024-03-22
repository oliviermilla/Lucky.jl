export SMAIndicator

struct SMAIndicator{LT,U,V} <: ValueIndicator{V}
    value::U
end

function SMAIndicator(length::Integer, value::V) where {V}
    length > 0 || error("SMAIndicator: $(length) must be positive to calculate a moving average.")
    return SMAIndicator{Val(length),Union{Missing,V},V}(value)
end

# mean returns a float when given integers
IndicatorType(::Type{SMAIndicator}, length::Integer, V::Type{<:Integer}) = SMAIndicator{Val(length),Union{Missing,Float64},Float64}