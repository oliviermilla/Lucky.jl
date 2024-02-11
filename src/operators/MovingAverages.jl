module MovingAverages

export sma

using Statistics

using Rocket

# Operators
sma(length::U) where {U<:Unsigned} = SmaOperator{U}(length)
sma(length::S) where {S<:Signed} = sma(convert(unsigned(S), length))

struct SmaOperator{LT} <: InferableOperator
    length::LT
end

Rocket.operator_right(::SmaOperator, ::Type{L}) where {L} = Union{Missing,Float64}

function Rocket.on_call!(::Type{L}, ::Type{R}, operator::SmaOperator{LT}, source) where {L,R,LT}
    return proxy(R, source, SmaProxy{L,LT}(operator.length))
end

# Proxy
struct SmaProxy{L,LT} <: ActorProxy
    length::LT
end

function Rocket.actor_proxy!(::Type{Right}, proxy::SmaProxy{Left,LT}, actor::A) where {Left,Right,A,LT}
    return SmaActor{A,Left,LT}(proxy.length, actor)
end

# Observable
mutable struct SmaActor{A,Left,LT} <: Actor{Left}
    lastN::Vector{Union{Missing,Left}}
    initCounter::LT
    next::A
end
SmaActor{A,Left,LT}(length::LT, actor::A) where {A,Left,LT} = SmaActor{A,Left,LT}(Vector{Union{Missing,Left}}(missing, length), LT(0), actor)
function Rocket.on_next!(actor::SmaActor, data::T) where {T}
    circshift!(actor.lastN, -1)
    actor.lastN[lastindex(actor.lastN)] = data
    next!(actor.next, Statistics.mean(actor.lastN))
end

Rocket.on_error!(actor::SmaActor, error) = error!(actor.next, error)
Rocket.on_complete!(actor::SmaActor) = complete!(actor.next)

end