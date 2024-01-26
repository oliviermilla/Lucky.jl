using Test

using Lucky
using Rocket

include("test_currencies.jl")
include("test_instruments.jl")

include("test_ohlcs.jl")
include("samplers/test_ohlc_samplers.jl")

include("test_orders.jl")
include("exchanges/test_fake_exchanges.jl")

# Extensions
include("ext/test_timeseries.jl")
# include("ext/test_dydxv3_ohlc_operators.jl")