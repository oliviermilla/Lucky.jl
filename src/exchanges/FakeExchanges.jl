struct FakeExchange <: AbstractExchange
    orderbook::InMemoryOrderBook
    next::AbstractSubject
end

@inline FakeExchange(subject::Subject) = FakeExchange(orderbook(:inmemory), subject)

exchange(::Val{:fake}, subject::Subject) = FakeExchange(subject)

Rocket.on_error!(actor::FakeExchange, error) = error!(actor.next, error)
Rocket.on_complete!(actor::FakeExchange) = complete!(actor.next)

function Rocket.on_next!(exchange::FakeExchange, order::O) where {O<:AbstractOrder}
    instr = typeof(order.instrument)
    if !haskey(exchange.orderbook.pendingOrders, instr)
        exchange.orderbook.pendingOrders[instr] = Vector{AbstractOrder}()
    end
    push!(exchange.orderbook.pendingOrders[instr], order)
end
function Rocket.on_next!(exchange::FakeExchange, orders::Vector{O}) where {O<:AbstractOrder}
    foreach(order -> on_next!(exchange, order), orders)
end

# === Quotes handling
function Rocket.on_next!(exchange::FakeExchange, qte::AbstractQuote)
    instr = typeof(qte.instrument)
    haskey(exchange.orderbook.pendingOrders, instr) || return

    todel = nothing
    tonext = nothing
    for (idx, order) in enumerate(exchange.orderbook.pendingOrders[instr])
        executed = match(order, qte)
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
    isnothing(todel) || deleteat!(exchange.orderbook.pendingOrders[instr], todel)
    isnothing(tonext) || foreach(x -> next!(exchange.next, x), tonext)
end

fee(::AbstractOrder, price::Number) = zero(price)