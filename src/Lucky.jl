module Lucky
using Dates
using Rocket
using UUIDs # Used by FakeExchange

# ==== Units
include("Constants.jl")
include("Units.jl")
include("units/Percentages.jl")
include("units/Timestamps.jl")
include("units/Currencies.jl")

# ==== Bars
include("Ohlcs.jl")

# ==== Instruments
include("Instruments.jl")
include("instruments/Bonds.jl")
include("instruments/Cash.jl")
include("instruments/Futures.jl")
include("instruments/Stocks.jl")

# ==== Other Data Types
include("Quotes.jl")
include("Positions.jl")
include("Orders.jl")
include("Fills.jl")
include("Trades.jl")
include("Indicators.jl")

# ==== Services
include("Services.jl")
include("observables/Feeders.jl")
include("Blotters.jl")
include("blotters/InMemoryBlotters.jl")
include("OrderBooks.jl")
include("Exchanges.jl")
include("exchanges/FakeExchanges.jl") # Must be after OrderBooks

include("Strategies.jl")

# === Operators

include("operators/ohlc.jl")
include("operators/rolling.jl")
include("operators/ema.jl") # Must be after rolling
include("operators/sma.jl") # Must be after rolling
include("operators/highwatermark.jl")
include("operators/drawdown.jl") # Must be after HighWaterMark

end # module Lucky
