export InMemoryBlotter

struct InMemoryBlotter <: AbstractBlotter
    fills::Dict{Type{<:Instrument}, Vector{Fill}} # TODO Optimize
    next::AbstractSubject
end
@inline InMemoryBlotter(subject::Subject) = InMemoryBlotter(Dict{Type{<:Instrument}, Vector{Fill}}(), subject)

blotter(::Val{:inmemory}, subject::Subject) = InMemoryBlotter(subject)

function Rocket.on_next!(actor::InMemoryBlotter, fill::Fill)
    key = typeof(fill.order.instrument)
    if !haskey(actor.fills, key)
        actor.fills[key] = Vector{Fill}()
    end
    push!(actor.fills[key], fill)
    aggSize = sum(f -> f.size, actor.fills[key])
    position = Position(fill.order.instrument, aggSize, fill.timestamp)
    next!(actor.next, position)
end

Rocket.on_error!(actor::InMemoryBlotter, error) = error!(actor.next, error)
Rocket.on_complete!(actor::InMemoryBlotter) = complete!(actor.next)