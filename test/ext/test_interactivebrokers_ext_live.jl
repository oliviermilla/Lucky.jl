# Requires a live connection to ibkr

using InteractiveBrokers

client = Lucky.service(:interactivebrokers)

InteractiveBrokers.reqMarketDataType(client, InteractiveBrokers.DELAYED)

stock = Stock(:AAPL, :USD)

qt = Lucky.feed(client, stock) # reqMktData should return a Subscribable

subscribe!(qt |> take(3), logger())

connect(client)

sleep(100)