module Fills

export AbstractFill, FillType
export Fill

using Lucky.Orders
import Lucky.Units as Units

using Dates

abstract type AbstractFill end

FillType(::F) where {F<:AbstractFill} = F

struct Fill{O,S,D} <: AbstractFill
    id::String
    order::O
    price::Float64
    size::S
    fee::Float64
    timestamp::D
end

Units.currency(::Fill{O,S,D}) where {O<:AbstractOrder,S,D} = Units.currency(O)

end