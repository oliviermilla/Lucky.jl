module Indicators

export AbstractIndicator
export SMAIndicator

abstract type AbstractIndicator end

struct SMAIndicator{LT} <: AbstractIndicator
    value::Union{Missing,Float64}
end

# value(ind::T) where{T<:AbstractIndicator} = ind.value # error("You probably forgot to implement value() for $(T)!")

Base.:+(x::I, y::I) where {I<:AbstractIndicator} = I(x.value + y.value)
Base.:-(x::I, y::I) where {I<:AbstractIndicator} = I(x.value - y.value)
Base.isless(x::SMAIndicator{I}, y::SMAIndicator{J}) where {I,J} = isless(x.value, y.value)

end