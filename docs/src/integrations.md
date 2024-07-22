# [Integrations](@id integrations)

Lucky offers seamless integration with numerous third party packages through [extensions](https://pkgdocs.julialang.org/v1/creating-packages/#Conditional-loading-of-code-in-packages-(Extensions)).

Integrated packages share common interfaces.

# Current Integrations

| Service            | Description                                                                                                               | Required Library                                                            |
|--------------------|---------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------|
| FakeExchange       | Mimicks the behavior of an exchange. Mostly used to backtest trading strategies.                                          | None                                                                        |
| InMemoryBlotter    | Provides a simple Blotter.                                                                                                | None                                                                        |
| InteractiveBrokers | Integrate InteractiveBokers.com client API                                                                                | [InteractiveBrokers](https://github.com/oliviermilla/InteractiveBrokers.jl) |
| MarketData         | Get Historical price series from Yahoo, Fred.                                                                             | [MarketData](https://github.com/JuliaQuant/MarketData.jl)                   |
| Random             | Random                                                                                                                    | Random                                                                      |
| TimeSeries         | A native Julia library providing a DataType to handle Time Series data. Used by MarketData but can be used independently. | [TimeSeries](https://github.com/JuliaStats/TimeSeries.jl)                   |

## FakeExchange

FakeExchange is part of Lucky. No extra package is required.

```@example
    using Lucky
    using Rocket
    fills = Subject(Fill) # Where the fake exchange will post fills.
    ex = exchange(:fake, fills)
```

## InMemoryBlotter

```@example
    using Lucky
    using Rocket
    positions = Subject(Position) # Where the blotter will post the current positions
    bl = blotter(:inmemory, positions)
```

## InteractiveBrokers

Add [InteractiveBrokers](https://github.com/oliviermilla/InteractiveBrokers.jl) to your `Project.toml` file.

```@example
    using Lucky
    using InteractiveBrokers
    client = service(:interactivebrokers) # Client holding the connection and settings.
    
    InteractiveBrokers.reqMarketDataType(client, InteractiveBrokers.DELAYED) # Specify the data type you wish to stream.

    stock = Stock(:AAPL, :USD)

    qt = trades(client, stock) # Will return a Subject that will stream the trades.
```    

## MarketData

Add [MarketData](https://github.com/JuliaQuant/MarketData.jl) to your `Project.toml` file. Note that the package requires the `TimeSeries`package, so you don't need to add it on your own to get native support for the `TimeSeries` format.

```@example
    using Lucky
    using MarketData
    using Rocket
    symbol = :AAPL

    # Define the historical period you wish to retrieve.
    today = Dates.now(Dates.UTC)
    periodEnd = Dates.firstdayofweek(today)
    periodStart = Dates.lastdayofweek(today - Month(3))
    opts = MarketData.YahooOpt(period1=periodStart, period2=periodEnd, interval="1d")

    # Get the data
    data = MarketData.yahoo(symbol, opts)

    # Create the Instrument
    stock = Stock(symbol, :USD)

    # Now you have a couple of options

    # Stream the raw data
    Rocket.from(data)

    # Stream the data as quotes
    quotes(stock, data)
```

## Random	

Add Standard `Random` Libray to your `Project.toml`file.

```@example
using Lucky
using Rocket
using Random
using Dates

# Generate random Ohlc of 5 minutes interval.
period = Minute(5)
ohlcs = rand(Ohlc{DateTime}, period, 10)

# Stream the Ohlcs
Rocket.from(ohlcs)
```

## TimeSeries

Add [TimeSeries](https://github.com/JuliaStats/TimeSeries.jl) to your `Project.toml` file.