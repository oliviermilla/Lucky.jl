export DrawdownIndicator

mutable struct DrawdownIndicator{U,V} <: ValueIndicator{V}
    highwatermark::U
    value::U
end

#DrawdownIndicator(highwatermark=missing, value::V) where {V} = DrawdownIndicator{Union{Missing,V},V}(value)