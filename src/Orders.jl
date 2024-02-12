module Orders

export AbstractOrder, LimitOrder, MarketOrder

using Lucky.Constants
using Lucky.Instruments

abstract type AbstractOrder end

struct MarketOrder{I} <: AbstractOrder
    instrument::I
    size::Real
end

struct LimitOrder{I} <: AbstractOrder
    instrument::I
    size::Real
    limit::Float64
end

end