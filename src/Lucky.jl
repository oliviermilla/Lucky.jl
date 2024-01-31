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
using .Positions
export Position

# Constants
include("Constants.jl")
using .Constants
export ORDER_SIDE

include("Ohlcs.jl")
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
using .Orders
export AbstractOrder, LimitOrder, MarketOrder

include("Exchanges.jl")
using .Exchanges
export AbstractExchange, FakeExchange, FakePosition

end # module Lucky
