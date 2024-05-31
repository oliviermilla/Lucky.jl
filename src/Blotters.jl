module Blotters

export AbstractBlotter

using Rocket

export blotter

function blotter end

blotter(x::Any) = error("You probably forgot to implement blotter($(x))")
@inline blotter(s::Symbol) = blotter(Val(s))

abstract type AbstractBlotter <: Actor{Any} end

include("blotters/InMemoryBlotters.jl")
using .InMemoryBlotters
export InMemoryBlotter

end