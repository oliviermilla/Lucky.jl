module DydxV3Ext

using Lucky

using DydxV3
using Rocket
using Dates

Rocket.on_next!(actor::Lucky.Operators.OhlcObservableFromTrade, data::DydxV3.Trade) = update!(actor, data)

# Logic
@inline function set!(actor::Lucky.Operators.OhlcObservableFromTrade, trade::DydxV3.Trade)
    actor.first = trade.createdAt
    actor.last = trade.createdAt
    actor.open = trade.price
    actor.high = trade.price
    actor.low = trade.price
    actor.close = trade.price
    actor.set = true
end

@inline reset!(actor::Lucky.Operators.OhlcObservableFromTrade) = actor.set = false

# Possible TODO: Ohlc on close (versus open) time. Possible first ohlc behavior
# See https://quant.stackexchange.com/questions/69861/formal-definition-of-open-high-low-close-ohlc-price-data
function update!(actor::Lucky.Operators.OhlcObservableFromTrade, trade::DydxV3.Trade)
    if actor.set
        actor.last = trade.createdAt
        actor.close = trade.price

        if trade.price > actor.high
            actor.high = trade.price
        elseif trade.price < actor.low
            actor.low = trade.price
        end
    else
        set!(actor, trade)
    end

    if (actor.cutoff && second(trade.createdAt) == 59) || trade.createdAt - actor.first == 60 # Is this always reliable ?
        ohlc = Ohlc{DateTime}(actor.open, actor.high, actor.low, actor.close, actor.first)
        next!(actor.next, ohlc)
        reset!(actor)
    end
end

# using DydxV3
# using Rocket

# # See https://github.com/biaslab/Rocket.jl/blob/main/src/observable/network.jl

# struct DydxV3WebSocketObserver{T} <: ScheduledSubscribable{T}
#     client::DydxV3.WebSockets.Client
# end

# struct DydxV3Subscription <: Teardown 
#     client::DydxV3.WebSockets.Client
# end

# as_teardown(::Type{<:DydxV3Subscription}) = UnsubscribableTeardownLogic()
# on_unsubscribe!(sub::DydxV3Subscription) = close(sub.client)

# dydxv3_account(account::DydxV3.Account) = DydxV3WebSocketObserver{type of data returned by the client}(new client, save account number)
# #dydxv3_trades(pair::String) = TODO same as above
# function dydxv3_trades(pair::String)
#     DydxV3.WebSockets.subscribeToTrades(pair, client) do cli, tradeWrapper
#         for trade in tradeWrapper.contents.trades
#             next!(tradesSubject, trade) # market object may not include the symbol, use the dictionary key
#         end
#     end
# end

# function on_subscribe!(obs::DydxV3WebSocketObserver{T}, actor)
#     @spawn begin
#         try
#             obs.client.open(send subscriptions requests here or below) do data
#                 next!(data, actor)
#             end
#         catch err
#             error!(actor, err)
#         end
#     end
#     return DydxV3Subscription(obs.client)
# end

end