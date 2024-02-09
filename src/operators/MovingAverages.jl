module MovingAverages

export sma

using Rocket

# Operator
sma(length::UInt16=UInt16(9)) = SmaOperator(length)

struct SmaOperator <: InferableOperator
    length::UInt16
end

Rocket.operator_right(::SmaOperator, ::Type{L}) where {L} = L

function Rocket.on_call!(::Type{L}, ::Type{R}, operator::SmaOperator, source) where {L,R}
    return proxy(R, source, SmaProxy(operator.length))
end

# Proxy
struct SmaProxy <: ActorProxy
    length::UInt16
end

function Rocket.actor_proxy!(::Type{R}, proxy::SmaProxy, actor::A) where {R, A}
    return SmaActor{A,R}(proxy.length, actor)
end

# Observable
mutable struct SmaActor{A} <: Actor{A}
    lastN::Vector{T}
    initCounter::UInt16
    next::A
end
SmaActor{A,T}(length::UInt16, actor::A) where {A,T} = SmaActor{A,T}(zeros(T, length), UInt16(0), actor)
function Rocket.on_next!(actor::SmaActor, data::T) where {T}
    circshift!(actor.lastN, -1)
    actor.lastN[lastindex(lastN)] = data
    if (actor.initCounter < length(lastN))
        actor.initCounter += 1
        return
    end
    next!(actor.next, average(lastN))
end

Rocket.on_error!(actor::SmaActor, error) = error!(actor.next, error)
Rocket.on_complete!(actor::SmaActor) = complete!(actor.next)

end