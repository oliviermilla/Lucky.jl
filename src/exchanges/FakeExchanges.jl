module FakeExchanges

export FakeExchange, FakePosition

using Lucky.Constants
using Lucky.Exchanges
using Lucky.Orders
using Lucky.Ohlcs

using Rocket
using Dates

struct FakePosition
    size::Float64
    avgPrice::Float64
    createdAt::DateTime
end

struct FakeExchange <: AbstractExchange
    pendingOrders::Vector{Any}
    next::AbstractSubject
end

@inline FakeExchange(subject::Subject) = FakeExchange(Vector{Any}(), subject)
@inline FakeExchange() = FakeExchange(Subject(FakePosition))

Rocket.on_error!(actor::FakeExchange, error) = error!(actor.next, error)
Rocket.on_complete!(actor::FakeExchange) = complete!(actor.next)

Rocket.on_next!(exchange::FakeExchange, order::O) where {O<:AbstractOrder} = push!(exchange.pendingOrders, order)
Rocket.on_next!(exchange::FakeExchange, order::Vector{O}) where {O<:AbstractOrder} = append!(exchange.pendingOrders, order)
function Rocket.on_next!(exchange::FakeExchange, ohlc::Ohlc)
    todel = nothing
    tonext = nothing
    for (idx, order) in enumerate(exchange.pendingOrders)
        executed = match(order, ohlc)
        isnothing(executed) && continue
        if isnothing(todel)
            todel = Vector{Int}()
        end
        push!(todel, idx)
        if isnothing(tonext)
            tonext = Vector{FakePosition}()
        end
        push!(tonext, executed)        
    end
    isnothing(todel) || deleteat!(exchange.pendingOrders, todel)
    isnothing(tonext) || foreach(x -> next!(exchange.next, x), tonext)
end

match(ord::MarketOrder, ohlc::Ohlc) = FakePosition(ord.size, ohlc.open, ohlc.timestamp)
function match(ord::LimitOrder, ohlc::Ohlc)
    if ord.limit >= ohlc.low && ord.limit <= ohlc.high
        return FakePosition(ord.size, ord.limit, ohlc.timestamp)
    end
    return nothing
end
end