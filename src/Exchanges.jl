export exchange

@inline exchange(s::Symbol, params...) = exchange(Val(s), params...)

abstract type AbstractExchange <: Actor{Any} end
