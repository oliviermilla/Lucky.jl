export EMAIndicator

mutable struct EMAIndicator{LT,U,V} <: ValueIndicator{V}
    length::Integer
    value::U
end

function EMAIndicator(length::Integer, value::V) where {V}
    length > 0 || error("EMAIndicator: $(length) must be positive to calculate a moving average.")
    return EMAIndicator{Val(length),Union{Missing,V},V}(length, value)
end