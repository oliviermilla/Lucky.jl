module Indicators

export AbstractIndicator
export SMAIndicator

abstract type AbstractIndicator end

# value(ind::T) where{T<:AbstractIndicator} = ind.value # error("You probably forgot to implement value() for $(T)!")

Base.:+(x::I, y::I) where {I<:AbstractIndicator} = I(x.value + y.value)
Base.:-(x::I, y::I) where {I<:AbstractIndicator} = I(x.value - y.value)
Base.isless(x::I, y::I) where {I<:AbstractIndicator} = isless(x.value, y.value)

struct SMAIndicator{LT, T} <: AbstractIndicator
    value::Union{Missing,T}    
end
function SMAIndicator(length::Integer, value::Union{Missing, Number}=missing)
    length > 0 || error("SMAIndicator: $(length) must be positive to calculate a moving average.")
    return SMAIndicator{Val(length),typeof(value)}(value)
end

Base.isless(x::SMAIndicator{I}, y::SMAIndicator{J}) where {I,J} = isless(x.value, y.value)

end