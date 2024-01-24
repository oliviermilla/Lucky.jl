module Orders

export AbstractOrder, LimitOrder, MarketOrder

using Lucky.Constants

abstract type AbstractOrder end

struct MarketOrder <: AbstractOrder
    size::Float64
end

struct LimitOrder <: AbstractOrder
    size::Float64
    limit::Float64
end

end