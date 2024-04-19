using Test
using Dates
using Lucky
using Rocket
import MarketData # Import to avoid conflicting names such as timestamp()

# A strategy is a bunch of 'blocks' connected (synchronously or asynchronously) together
# A 'Data' block that will provide us with the feed of data we want (in our case the OHLCs quotes of AAPL taken from yahoo)
# A 'Strategy' block that will receive the AAPL quotes from the 'Data' block and output Orders
# A 'FakeExchange' block that will process the Orders and output Fills
# A 'Blotter' block that will receive all Fills and keep a logging of them, producing Positions (aggregate of the fills)
# A 
# Once all blocks are create, all we need is to wire them together.
# Each block can subscribe to as many feeds as it needs.
# For instance, if your 'Strategy' block needs to know the current Position, just have it subscribed to the Blotter block
#
# There is no limit to the wiring that can be done.
# All blocks are Rocket.jl types and can be mixed up with the operators and other generic 'blocks' the library provides.
# For instance, you could add a 'network' blotter to the scheme that sends everything it is subscribed to over a network or a database.
# 
# This makes Lucky.jl  very powerful to develop, extend and integrate systems incrementally, from what could be a very simple R&D code to production. 
@testset "Golden Cross" begin
    symbol = :AAPL

    # Use the offline dataset provided by the MarketData package
    data = getfield(MarketData, symbol)

    # Or uncomment these lines to get 3 months of data from yahoo from whatever period
    # today = Dates.now(Dates.UTC)
    # periodEnd = Dates.firstdayofweek(today)
    # periodStart = Dates.lastdayofweek(today - Month(3))
    # opts = MarketData.YahooOpt(period1=periodStart, period2=periodEnd, interval="1d")
    # data = MarketData.yahoo(symbol, opts)

    # Create the Instruments
    cash = Cash(:USD)
    stock = Stock(symbol, :USD)

    TCashType = InstrumentType(cash)
    TStockType = InstrumentType(stock)
    TQuoteType = QuoteType(TStockType, Ohlc{Date})

    CashPositionType = PositionType(cash, Float64, Date)
    StockPositionType = PositionType(stock, Int64, TQuoteType)

    # Create the feeds where each block submits or reads new data (pub/sub)   
    quotes = Subject(TQuoteType) #Quotes feed. Subscribe to it to get the quotes.
    orders = Subject(AbstractOrder) # Orders feed. Subscribe to it to get the orders created by our Strategy.
    fills = Subject(AbstractFill) # Fills feed. Subscribe to it to get the fills of the exchange.
    positions = Subject(Position) # Positions feed. Subscribe to it to get the positions returned by the exchange.

    # Iterate the data (as if a live feed)
    # Map the data to quotes of the above stock instrument
    # Multicast to the quotes feed so any actor can subscribe.    
    source = Rocket.from(data) |> map(TQuoteType, ohlc -> Quote(stock, ohlc)) |> multicast(quotes)
    slowSMA = source |> sma(5)
    fastSMA = source |> sma(2)

    SlowIndicatorType = IndicatorType(SMAIndicator, 2, TQuoteType)
    FastIndicatorType = IndicatorType(SMAIndicator, 5, TQuoteType)

    # Write the strategy
    mutable struct GoldenCross{A} <: AbstractStrategy
        cashPosition::Union{Nothing,CashPositionType}
        aaplPosition::Union{Nothing,StockPositionType}
        prevSlowSMA::SlowIndicatorType
        prevFastSMA::FastIndicatorType
        slowSMA::SlowIndicatorType
        fastSMA::FastIndicatorType
        next::A
    end

    GoldenCross(actor::A) where {A} = GoldenCross(
        nothing,
        nothing,
        SlowIndicatorType(missing),
        FastIndicatorType(missing),
        SlowIndicatorType(missing),
        FastIndicatorType(missing),
        actor
    )

    # This is called every time a slow SMAIndicator is received
    function Rocket.on_next!(strat::GoldenCross, data::SlowIndicatorType)
        @debug "Received slow SMA: $(data)"
        strat.prevSlowSMA = strat.slowSMA
        strat.slowSMA = data
        trade(strat)
    end

    # This is called every time a fast SMAIndicator is received
    function Rocket.on_next!(strat::GoldenCross, data::FastIndicatorType)
        @debug "Received fast SMA: $(data)"
        strat.prevFastSMA = strat.fastSMA
        strat.fastSMA = data
        trade(strat)
    end

    # This is called every time a new effective cash position is received
    function Rocket.on_next!(strat::GoldenCross, position::CashPositionType)
        @debug "Received cash position: $(position)"
        strat.cashPosition = position
        # trade(strat) Current strategy does not depend on position
    end

    # This is called every time a new effective AAPL position is received
    function Rocket.on_next!(strat::GoldenCross, position::StockPositionType)
        @debug "Received stock position: $(position)"
        strat.aaplPosition = position
        # trade(strat) Current strategy does not depend on position
    end

    # This is called every time one of the subscription finishes its stream
    Rocket.on_complete!(strat::GoldenCross) = complete!(strat.next)

    function trade(strat::GoldenCross)
        if strat.prevFastSMA < strat.prevSlowSMA && strat.fastSMA >= strat.slowSMA
            order = MarketOrder(stock, 1)
            next!(strat.next, order) # Send the order to whatever is subscribed.
            return
        end

        if strat.prevFastSMA > strat.prevSlowSMA && strat.fastSMA <= strat.slowSMA
            order = MarketOrder(stock, -1)
            next!(strat.next, order) # Send the order to whatever is subscribed.
            return
        end
    end    

    # Create a 'strategy' block and subscribe to the feed it needs
    strat = GoldenCross(orders)
    subscribe!(slowSMA, strat)
    subscribe!(fastSMA, strat)
    subscribe!(positions, strat)

    # Create an 'exchange' block (replace with a true exchange in prod)
    # and subscribe to the feeds it needs
    exchange = FakeExchange(fills)
    subscribe!(quotes, exchange)
    subscribe!(orders, exchange)

    # Create a 'blotter' block that will reside in memory
    # Subscribe to the feeds it needs (Fills)
    blotter = InMemoryBlotter(positions)
    subscribe!(fills, blotter)

    # Print to the feed
    subscribe!(orders, logger("Orders"))
    subscribe!(fills, logger("Fills"))
    subscribe!(positions, logger("Positions"))
    # @show blotter.fills

    # Get the initial positions from the source data (so timestamps line up)
    # In prod you'll get your current positions from the feed of your broker connexion
    next!(positions, CashPositionType(cash, 1000.0, MarketData.timestamp(data[1])[1]))
    next!(positions, StockPositionType(stock, zero(Float64), MarketData.timestamp(data[1])[1]))

    # Connect the source. This will start feeding data. Let's roll!
    connect(source)
end
