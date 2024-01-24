module InMemoryBlotters

export InMemoryBlotter

using Lucky.Blotters

using Rocket

struct InMemoryBlotter <: AbstractBlotter
    positions::Vector{Any}
    next::AbstractSubject
end
@inline InMemoryBlotter(subject::Subject) = InMemoryBlotter(Vector{Any}(), subject)

Rocket.on_error!(actor::InMemoryBlotter, error) = error!(actor.next, error)
Rocket.on_complete!(actor::InMemoryBlotter) = complete!(actor.next)

end