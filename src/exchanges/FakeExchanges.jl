module FakeExchanges

export FakeExchange, FakePosition

using Lucky.Constants
using Lucky.Exchanges
using Lucky.Fills
using Lucky.Instruments
using Lucky.Orders
using Lucky.Quotes
using Lucky.Ohlcs

using Rocket
using Dates
using UUIDs

struct FakeExchange <: AbstractExchange
    pendingOrders::Dict{Type{<:Instrument},Vector{AbstractOrder}}
    next::AbstractSubject
end

@inline FakeExchange(subject::Subject) = FakeExchange(Dict{Type{<:Instrument},Vector{AbstractOrder}}(), subject)

Rocket.on_error!(actor::FakeExchange, error) = error!(actor.next, error)
Rocket.on_complete!(actor::FakeExchange) = complete!(actor.next)

function Rocket.on_next!(exchange::FakeExchange, order::O) where {O<:AbstractOrder}
    instr = typeof(order.instrument)
    if !haskey(exchange.pendingOrders, instr)
        exchange.pendingOrders[instr] = Vector{AbstractOrder}()
    end
    push!(exchange.pendingOrders[instr], order)
end
function Rocket.on_next!(exchange::FakeExchange, orders::Vector{O}) where {O<:AbstractOrder}
    foreach(order -> on_next!(exchange, order), orders)    
end

# === Quotes handling
function Rocket.on_next!(exchange::FakeExchange, qte::AbstractQuote)
    instr = typeof(qte.instrument)
    haskey(exchange.pendingOrders, instr) || return

    todel = nothing
    tonext = nothing
    for (idx, order) in enumerate(exchange.pendingOrders[instr])
        executed = match(order, qte.price, timestamp(qte))
        isnothing(executed) && continue
        if isnothing(todel)
            todel = Vector{Int}()
        end
        push!(todel, idx)
        if isnothing(tonext)
            tonext = Vector{Fill}()
        end
        push!(tonext, executed)
    end
    isnothing(todel) || deleteat!(exchange.pendingOrders[instr], todel)
    isnothing(tonext) || foreach(x -> next!(exchange.next, x), tonext)
end

@inline match(ord::MarketOrder, price::Number, stamp::D) where{D} = Fill(fillUUID(), ord, price, ord.size, fee(ord, price), stamp)
function match(ord::LimitOrder, price::Number, stamp::D) where{D}
    ord.size >= zero(ord.size) && ord.limit >= price && return Fill(fillUUID(), ord, price, ord.size, fee(ord, price), stamp)
    ord.limit <= price && return Fill(fillUUID(), ord, price, ord.size, fee(ord, price), stamp)
    return nothing
end

# OHLC handling
@inline match(ord::MarketOrder, ohlc::Ohlc, stamp::D) where{D} = match(ord, ohlc.open, stamp)
function match(ord::LimitOrder, ohlc::Ohlc)
    ord.limit >= ohlc.low && ord.limit <= ohlc.high && return Fill(fillUUID(), ord, ord.limit, ord.size, fee(ord, ord.limit), ohlc.timestamp)    
    return nothing
end

fillUUID() = string(uuid5(uuid4(), "FakeExchange"))

fee(ord::AbstractOrder, price::Number)= zero(price)

end