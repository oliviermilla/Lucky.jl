export DrawdownIndicator

mutable struct DrawdownIndicator{U,V} <: ValueIndicator{V}
    value::U
end

DrawdownIndicator(value::V) where {V} = DrawdownIndicator{Union{Missing,V},V}(value)