using Test

using Lucky
using Rocket

using Dates
using Random

# Uncomment if you want to run examples
# include("../examples/goldencross.jl")

# Same order as in Lucky.jl

include("test_units.jl")
include("test_currencies.jl")
include("test_instruments.jl")
include("test_quotes.jl")
include("test_positions.jl")
include("test_orders.jl")
include("test_fills.jl")
include("test_indicators.jl")

include("test_ohlcs.jl")
include("samplers/test_ohlc_samplers.jl")
include("operators/test_rolling_operator.jl")
include("operators/test_ema_operator.jl")
include("operators/test_sma_operator.jl")
include("operators/test_highwatermark_operator.jl")
include("operators/test_drawdown_operator.jl")

include("exchanges/test_fake_exchanges.jl")
include("blotters/test_in_memory_blotters.jl")

# Extensions
include("ext/test_timeseries.jl")
include("ext/test_dydxv3_ohlc_operators.jl")