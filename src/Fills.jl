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
    size::Float64
    fee::Float64
    createdAt::DateTime
end

end