export RollingIndicator

struct RollingIndicator{LT,T,V} <: IterableIndicator{V}
    value::T
end

RollingIndicator(length::Int, value::T) where {V,T<:AbstractArray{V}} = RollingIndicator{Val(length),T,V}(value)