module Exchanges

export AbstractExchange

using Rocket

abstract type AbstractExchange <: Actor{Any} end

include("exchanges/FakeExchanges.jl")
using .FakeExchanges
export FakeExchange, FakePosition
end