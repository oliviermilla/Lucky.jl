# Requires a live connection to ibkr

using InteractiveBrokers

client = Lucky.service(:interactivebrokers)

InteractiveBrokers.reqMarketDataType(client, InteractiveBrokers.DELAYED)

stock = Stock(:AAPL, :USD)

qt = Lucky.feed(client, stock)

# accounts = Lucky.accounts(client)

# blotters = Vector{BlotterType(client)}()

# subscribe!(accounts, x -> begin
#     b = blotter(client, x)
#     push!(blotters, b)
# end
# )

struct MyStrategy <: Strategy    
    next::Subject
end

function on_next!(str::MyStrategy, qte::QuoteType(stock))
    ord = MarketOrder()
    next!(str.next, ord)
end

exchange = Lucky.exchange(client) # accounts ?


strat = MyStrategy()
subscribe!(qt, strat)

subscribe!(qt |> take(3), logger())

connect(client)

sleep(100)