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

currency(::MarketOrder{I,S}) where {I<:Instrument,S<:Number} = currency(I)
currency(::LimitOrder{I,S}) where {I<:Instrument,S<:Number} = currency(I)
currency(::Type{<:MarketOrder{I,S}}) where {I<:Instrument,S<:Number} = currency(I)
currency(::Type{<:LimitOrder{I,S}}) where {I<:Instrument,S<:Number} = currency(I)
