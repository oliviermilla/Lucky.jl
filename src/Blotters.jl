module Blotters

export AbstractBlotter

using Rocket

abstract type AbstractBlotter <: Actor{Any} end

include("blotters/InMemoryBlotters.jl")
using .InMemoryBlotters
export InMemoryBlotter
end