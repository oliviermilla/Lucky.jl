module Lucky

# Domain types
include("Units.jl")
using .Units
export Unit, Currency
export symbol, currency

include("Instruments.jl")
using .Instruments
export Instrument, Cash

include("Positions.jl")

# Constants
include("Constants.jl")
using .Constants
export ORDER_SIDE

include("Ohlcs.jl")
include("samplers/OhlcSamplers.jl") # No need to use / import export
include("operators/OhlcOperators.jl")

using .Ohlcs
export Ohlc

# Rocket Stuffs
using .OhlcOperators
export ohlc

include("Blotters.jl")
using .Blotters

include("Strategies.jl")
using .Strategies
export AbstractStrategy

include("Orders.jl")
include("samplers/OrderSamplers.jl") # No need to use import / export
using .Orders
export AbstractOrder, LimitOrder, MarketOrder

include("Exchanges.jl")
using .Exchanges
export AbstractExchange, FakeExchange, FakePosition

end # module Lucky
