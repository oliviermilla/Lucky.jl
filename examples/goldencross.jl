import MarketData

# We get a series of quote.
# The quotes get mapped to a slow and a fast moving averages
# A strategy reacts to the moving averages by sending orders to a FakeExchange
# The FakeExchange receives the quotes and executes the order appropriately
# The test confirms that we get the expected fills.
@testset "Golden Cross" begin
    symbol = :AAPL

    # Use the offline dataset provided by the MarketData package
    data = MarketData.AAPL

    # Or uncomment these lines to get 3 months of data from yahoo from whatever period
    # today = Dates.now(Dates.UTC)
    # periodEnd = Dates.firstdayofweek(today)
    # periodStart = Dates.lastdayofweek(today - Month(3))
    # opts = MarketData.YahooOpt(period1=periodStart, period2=periodEnd, interval="1d")
    # data = MarketData.yahoo(symbol, opts)

    # Create the Instruments
    cash = Cash(:USD)
    stock = Stock(symbol, :USD)

    CashType = InstrumentType(cash)
    StockType = InstrumentType(stock)
    QuoteType = QuoteType(StockType, Ohlc{Date})

    # Create the feeds    
    quotes = Subject(QuoteType) #Quotes feed. Subscribe to it to get the quotes.
    orders = Subject(AbstractOrder) # Orders feed. Subscribe to it to get the orders created by our Strategy.
    fills = Subject(AbstractFill) # Fills feed. Subscribe to it to get the fills of the exchange.
    positions = Subject(Position) # Positions feed. Subscribe to it to get the positions returned by the exchange.

    # Iterate the data as if it was a live feed
    # Map the data to quotes of the above stock instrument
    # Multicast to the quotes feed so any actor can subscribe.
    quoteType = QuoteType(stock, Ohlc{Date})
    source = Rocket.from(data) |> map(QuoteType, ohlc -> Quote(stock, ohlc)) |> multicast(quotes)
    slowSMA = source |> sma(5)
    fastSMA = source |> sma(2)

    SlowIndicatorType = IndicatorType(SMAIndicator, 2, quoteType)
    FastIndicatorType = IndicatorType(SMAIndicator, 5, quoteType)    
    mutable struct SmaStrategy{A} <: AbstractStrategy
        cashPosition::Position
        aaplPosition::Position
        prevSlowSMA::SlowIndicatorType
        prevFastSMA::FastIndicatorType
        slowSMA::SlowIndicatorType
        fastSMA::FastIndicatorType
        next::A
    end

    SmaStrategy(cashPosition::Position, actor::A) where {A} = SmaStrategy(
        cashPosition,
        Position(stock, zero(Float64)),
        SlowIndicatorType(missing),
        FastIndicatorType(missing),
        SlowIndicatorType(missing),
        FastIndicatorType(missing),
        actor
    )

    # This is called every time a slow SMAIndicator is received
    function Rocket.on_next!(strat::SmaStrategy, data::SlowIndicatorType)
        println("Received slow SMA: $(data)")
        strat.prevSlowSMA = strat.slowSMA
        strat.slowSMA = data
        trade(strat)
    end

    # This is called every time a fast SMAIndicator is received
    function Rocket.on_next!(strat::SmaStrategy, data::FastIndicatorType)
        println("Received fast SMA: $(data)")
        strat.prevFastSMA = strat.fastSMA
        strat.fastSMA = data
        trade(strat)
    end

    # This is called every time a new effective position is received
    #Rocket.on_next!(position::Position) 

    # This is called every time one of the subscription finishes its stream
    Rocket.on_complete!(strat::SmaStrategy) = println("Done!")

    function trade(strat::SmaStrategy)
        if strat.prevFastSMA < strat.prevSlowSMA && strat.fastSMA >= strat.slowSMA
            order = MarketOrder(stock, 1)
            next!(strat.next, order)
            return
        end

        if strat.prevFastSMA > strat.prevSlowSMA && strat.fastSMA <= strat.slowSMA
            order = MarketOrder(stock, -1)
            next!(strat.next, order)
            return
        end
    end

    strat = SmaStrategy(Position(cash, 1000.0), orders)
    subscribe!(slowSMA, strat)
    subscribe!(fastSMA, strat)
    #subscribe!(positions, strat)

    exchange = FakeExchange(fills)
    subscribe!(quotes, exchange)
    subscribe!(orders, exchange)
    subscribe!(orders, logger())

    # Connect the source. This will start the feed
    connect(source)
end