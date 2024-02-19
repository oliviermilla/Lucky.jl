module Operators

using Lucky.Indicators

using Rocket

# Order matters

include("operators/ohlc.jl")
include("operators/rolling.jl")
include("operators/ema.jl") # Must be after rolling
include("operators/sma.jl") # Must be after rolling

end