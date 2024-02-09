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
    source = Rocket.from(data) |> map(Quote, ohlc -> Quote(stock, ohlc)) |> multicast(quotes)
    # fastSMA = source |> sma(2)
    # slowSMA = source |> sma(5)    
    
    exchange = FakeExchange(positions)
    subscribe!(quotes, exchange)
    subscribe!(orders, exchange)
    subscribe!(quotes, logger())

    # Connect the source. This will start the feed
    connect(source)
end