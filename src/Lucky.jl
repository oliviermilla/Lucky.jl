module Lucky

# ==== Constants & Utils
include("Constants.jl")
using .Constants
export ORDER_SIDE

include("Utils.jl")

# ==== Financial types
include("Units.jl")
using .Units
export Unit, UnitType, Currency, CurrencyType, TimestampType
export symbol, currency

include("Ohlcs.jl")
using .Ohlcs
export Ohlc

include("Instruments.jl")
using .Instruments
export Instrument, InstrumentType
export Cash, Stock

include("Quotes.jl")
using .Quotes
export AbstractQuote, Quote, QuoteType
export timestamp

include("Positions.jl")
using .Positions
export Position, PositionType

include("Orders.jl")
using .Orders
export AbstractOrder, OrderType
export LimitOrder, MarketOrder

include("Fills.jl")
using .Fills
export AbstractFill, FillType
export Fill

include("Indicators.jl")
using .Indicators
export AbstractIndicator, IterableIndicator, ValueIndicator, IndicatorType
export DrawdownIndicator, EMAIndicator, HighWaterMarkIndicator, PeriodicValueIndicator, RollingIndicator, SMAIndicator

# ==== Rocket Dependant

include("Exchanges.jl")
using .Exchanges
export AbstractExchange, FakeExchange

include("Blotters.jl")
using .Blotters
export AbstractBlotter
export InMemoryBlotter

include("Operators.jl")
using .Operators
export drawdown, ema, highwatermark, ohlc, rolling, sma

include("Strategies.jl")
using .Strategies
export AbstractStrategy

# === Others

include("Performances.jl")
using .Performances
export drawdown

include("observables/Feeders.jl")
using .Feeders
# Do not export feed (too generic name)

include("Services.jl")
using .Services
# Do not export service (too generic name)

end # module Lucky
