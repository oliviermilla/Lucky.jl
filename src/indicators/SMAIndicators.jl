export SMAIndicator

struct SMAIndicator{LT,U,V} <: PeriodicValueIndicator{LT,V}
    value::U
end

function SMAIndicator(period::Integer, value::V) where {V}
    period > 0 || error("SMAIndicator: $(period) must be positive to calculate a moving average.")
    return SMAIndicator{period,Union{Missing,V},V}(value)
end

# mean returns a float when given integers
IndicatorType(::Type{SMAIndicator}, period::Integer, V::Type{<:Integer}) = SMAIndicator{period,Union{Missing,Float64},Float64}