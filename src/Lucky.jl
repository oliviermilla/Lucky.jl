module Lucky

using Rocket

# ==== Financial Types
include("Units.jl")
include("units/Percentages.jl")
include("units/Timestamps.jl")
include("units/Currencies.jl")

include("Ohlcs.jl")

# include("Instruments.jl")
# include("instruments/Cash.jl")
# include("instruments/Stocks.jl")
# #using .Instruments
# #export Instrument, InstrumentType
# #export Cash, Stock

# include("Quotes.jl")
# using .Quotes
# export AbstractQuote, Quote, QuoteType
# export timestamp

# include("Positions.jl")
# using .Positions
# export Position, PositionType

# include("Orders.jl")
# using .Orders
# export AbstractOrder, OrderType
# export LimitOrder, MarketOrder

# include("Fills.jl")
# using .Fills
# export AbstractFill, FillType
# export Fill

# include("Indicators.jl")
# using .Indicators
# export AbstractIndicator, IterableIndicator, ValueIndicator, IndicatorType
# export DrawdownIndicator, EMAIndicator, HighWaterMarkIndicator, PeriodicValueIndicator, RollingIndicator, SMAIndicator

# include("Trades.jl")
# using .Trades
# export AbstractTrade
# export Trade

# # ==== Rocket Dependant

# include("Exchanges.jl")
# using .Exchanges
# export AbstractExchange, FakeExchange

# include("Blotters.jl")
# using .Blotters
# export AbstractBlotter
# export InMemoryBlotter

# include("Operators.jl")
# using .Operators
# export drawdown, ema, highwatermark, ohlc, rolling, sma

# include("Strategies.jl")
# using .Strategies
# export AbstractStrategy

# # === Others

# include("observables/Feeders.jl")
# using .Feeders
# # Do not export feed (too generic name)

# include("Services.jl")
# using .Services
# # Do not export service (too generic name)

end # module Lucky
