export HighWaterMarkIndicator

mutable struct HighWaterMarkIndicator{U,V} <: ValueIndicator{V}
    value::U
end

HighWaterMarkIndicator(value::V) where {V} = HighWaterMarkIndicator{Union{Missing,V},V}(value)