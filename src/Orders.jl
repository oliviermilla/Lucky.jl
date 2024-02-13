module Orders

export AbstractOrder, OrderType
export LimitOrder, MarketOrder

using Lucky.Constants
using Lucky.Instruments
import Lucky.Units as Units

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

Units.currency(o::AbstractOrder) = Units.currency(o.instrument)
Units.currency(o::Type{<:MarketOrder{I,S}}) where {I,S} = Units.currency(I)
Units.currency(o::Type{<:LimitOrder{I,S}}) where {I,S} = Units.currency(I)

end