import MarketData

# We get a series of quote.
# The quotes get mapped to a slow and a fast moving averages
# A strategy reacts to the moving averages by sending orders to a FakeExchange
# The FakeExchange receives the quotes and executes the order appropriately
# The test confirms that we get the expected fills.
@testset "Golden Cross" begin
    symbol = :AAPL

    # Get 3 months of daily data from yahoo
    today = Dates.now(Dates.UTC)
    periodEnd = Dates.firstdayofweek(today)
    periodStart = Dates.lastdayofweek(today - Month(3))
    opts = MarketData.YahooOpt(period1=periodStart, period2=periodEnd, interval="1d")
    data = MarketData.yahoo(symbol, opts)

    # Create the Instrument
    stock = Stock(symbol, :USD)

    # Create the feeds    
    quotes = Subject(AbstractQuote) #Quotes feed. Subscribe to it to get the quotes.
    orders = Subject(AbstractOrder) # Orders feed. Subscribe to it to get the orders created by our Strategy.
    positions = Subject(Position) # Positions feed. Subscribe to it to get the positions returned by the exchange.

    # Iterate the data as if it was a live feed
    # Map the data to quotes of the above stock instrument
    # Multicast to the quotes feed so any actor can subscribe.
    source = Rocket.from(data) |> map(AbstractQuote, ohlc -> Quote(stock, ohlc)) |> multicast(quotes)    
    slowSMA = source |> sma(5)
    fastSMA = source |> sma(2)

    mutable struct SmaStrategy{A} <: AbstractStrategy
        position::Position
        prevSlowSMA::SMAIndicator{Val{5}}
        prevFastSMA::SMAIndicator{Val{2}}
        slowSMA::SMAIndicator{Val{5}}
        fastSMA::SMAIndicator{Val{2}}
        next::A
    end    

    SmaStrategy(actor::A) where {A} = SmaStrategy(
        Position(stock, zero(Float64)),
        SMAIndicator{Val{5}}(missing),
        SMAIndicator{Val{2}}(missing),
        SMAIndicator{Val{5}}(missing),
        SMAIndicator{Val{2}}(missing),
        actor
    )

    # This is called every time a slow SMAIndicator is received
    function Rocket.on_next!(strat::SmaStrategy, data::SMAIndicator{Val{5}})
        println("Received slow SMA: $(data)")
        strat.prevSlowSMA = strat.slowSMA
        strat.slowSMA = data
        trade(strat)
    end

    # This is called every time a fast SMAIndicator is received
    function Rocket.on_next!(strat::SmaStrategy, data::SMAIndicator{Val{2}})
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
        if strat.prevFastSMA < strat.prevSlowSMA
            if strat.fastSMA >= strat.slowSMA
                # TODO LONG
                return
            else
                # TODO CLOSE ANY LONG
                return
            end
        end
        if strat.prevFastSMA > strat.prevSlowSMA
            if strat.fastSMA <= strat.slowSMA
                # TODO SHORT
                return
            else
                # TODO CLOSE ANY SHORT
            end
        end
    end

    strat = SmaStrategy(orders)
    subscribe!(slowSMA, strat)
    subscribe!(fastSMA, strat)
    subscribe!(positions, strat)

    exchange = FakeExchange(positions)
    subscribe!(quotes, exchange)
    subscribe!(orders, exchange)
    #subscribe!(quotes, logger())

    # Connect the source. This will start the feed
    connect(source)
end