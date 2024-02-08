module Lucky

# ==== Constants
include("Constants.jl")
using .Constants
export ORDER_SIDE

# ==== Financial types
include("Units.jl")
using .Units
export Unit, Currency
export symbol, currency

include("Ohlcs.jl")
using .Ohlcs
export Ohlc

include("Instruments.jl")
using .Instruments
export Instrument, Cash, Stock
export instrument

include("Quotes.jl")
using .Quotes
export Quote

include("Positions.jl")
using .Positions
export Position

include("Orders.jl")
using .Orders
export AbstractOrder, LimitOrder, MarketOrder

include("Fills.jl")
using .Fills
export AbstractFill, Fill

# ==== Rocket Dependant

include("Exchanges.jl")
using .Exchanges
export AbstractExchange, FakeExchange, FakePosition

include("Blotters.jl")
using .Blotters
export AbstractBlotter
export InMemoryBlotter

include("operators/OhlcOperators.jl")
using .OhlcOperators
export ohlc

include("Strategies.jl")
using .Strategies
export AbstractStrategy

# === Others

include("Performances.jl")
using .Performances
export drawdown

end # module Lucky
