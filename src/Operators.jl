module Operators

using Rocket

# Order matters

include("operators/ohlc.jl")
include("operators/rolling.jl")
include("operators/sma.jl") # Must be after rolling

end