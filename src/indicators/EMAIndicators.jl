export EMAIndicator

mutable struct EMAIndicator{LT,U,V} <: PeriodicValueIndicator{LT, V}
    value::U
end

function EMAIndicator(period::Integer, value::V) where {V}
    period > 0 || error("EMAIndicator: $(period) must be positive to calculate a moving average.")
    return EMAIndicator{period,Union{Missing,V},V}(value)
end