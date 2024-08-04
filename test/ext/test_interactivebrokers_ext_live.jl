# Requires a live connection to ibkr

using InteractiveBrokers

client = Lucky.service(:interactivebrokers)

InteractiveBrokers.reqMarketDataType(client, InteractiveBrokers.DELAYED)

stock = Stock(:AAPL, :USD)

qt = Lucky.trades(client, stock)

positions = Lucky.positions(client)

subscribe!(qt |> take(3), logger("trades"))
subscribe!(positions, logger("positions"))

connect(client)

sleep(100)

# blotter = blotter(client)

# struct MyStrategy <: Strategy    
#     next::Subject
# end

# function on_next!(str::MyStrategy, qte::QuoteType(stock))
#     ord = MarketOrder()
#     next!(str.next, ord)
# end

# exchange = Lucky.exchange(client) # accounts ?


# strat = MyStrategy()
# subscribe!(qt, strat)