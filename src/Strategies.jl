module Strategies

using Rocket

export AbstractStrategy

abstract type AbstractStrategy <: Actor{Any} end

end