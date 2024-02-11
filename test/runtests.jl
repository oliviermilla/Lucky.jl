using Test

using Lucky
using Rocket

using Dates
using Random

# Same order as in Lucky.jl

include("test_currencies.jl")
include("test_instruments.jl")
include("test_quotes.jl")
include("test_positions.jl")
include("test_orders.jl")
include("test_fills.jl")

include("test_ohlcs.jl")
include("samplers/test_ohlc_samplers.jl")
include("operators/test_moving_averages.jl")

include("exchanges/test_fake_exchanges.jl")
include("blotters/test_inmemoryblotters.jl")

# Extensions
include("ext/test_timeseries.jl")
include("ext/test_dydxv3_ohlc_operators.jl")

include("test_performances.jl")

# Examples
# include("examples/goldencross.jl")