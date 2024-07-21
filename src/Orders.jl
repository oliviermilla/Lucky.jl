export AbstractOrder
export LimitOrder, MarketOrder
export OrderType

abstract type AbstractOrder end

OrderType(::O) where {O<:AbstractOrder} = O

struct MarketOrder{I,S} <: AbstractOrder
    instrument::I
    size::S
end

struct LimitOrder{I,S} <: AbstractOrder
    instrument::I
    size::S
    limit::Float64
end

currency(::Type{<:MarketOrder{I,S}}) where {I,S} = currency(I)
currency(::Type{<:LimitOrder{I,S}}) where {I,S} = currency(I)
