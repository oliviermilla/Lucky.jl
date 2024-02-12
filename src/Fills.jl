module Fills

export AbstractFill
export Fill

using Lucky.Orders

using Dates

abstract type AbstractFill end

struct Fill{O} <: AbstractFill
    id::String
    order::O
    price::Float64
    size::Real
    fee::Float64
    createdAt::TimeType
end

end