export exchange

function exchange end

exchange(x::Any) = error("You probably forgot to implement exchange($(x))")
@inline exchange(s::Symbol) = exchange(Val(s))

abstract type AbstractExchange <: Actor{Any} end
