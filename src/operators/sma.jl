export sma

using Statistics

sma(n::Int) = rolling(n) |> SmaOperator(n)

struct SmaOperator <: InferableOperator
    length::Int
end
Rocket.operator_right(op::SmaOperator, ::Type{L}) where {L<:Any} = IndicatorType(SMAIndicator, op.length, L)
Rocket.operator_right(op::SmaOperator, ::Type{<:IterableIndicator{Q}}) where {Q} = IndicatorType(SMAIndicator, op.length, Q)

smaFn(rolling) = Statistics.mean(rolling)

function Rocket.on_call!(::Type{L}, ::Type{R}, operator::SmaOperator, source) where {L,R}
    return proxy(R, source, Rocket.MapProxy{L,Function}(vec -> R(smaFn(vec))))
end

# Old implementation. Just keeping it for ref.
#
# Operators
# sma(length::Int64) = SmaOperator(length)

# rightType(length::Int64, ::Type{L}) where {L} = IndicatorType(SMAIndicator, length, L)

# struct SmaOperator <: InferableOperator
#     length::Int64
#     function SmaOperator(length::Int64)
#         length > 0 || error("SmaOperator: $(length) must be positive to calculate a moving average.")
#         return new(length)
#     end
# end

# Rocket.operator_right(op::SmaOperator, ::Type{L}) where {L} = rightType(op.length, L)

# function Rocket.on_call!(::Type{L}, ::Type{R}, operator::SmaOperator, source) where {L,R}
#     return proxy(R, source, SmaProxy(L, operator.length))
# end

# # Proxy
# struct SmaProxy <: ActorProxy
#     leftType::Type
#     length::Int64
# end

# function Rocket.actor_proxy!(::Type{R}, proxy::SmaProxy, actor::A) where {R,A}
#     return SmaActor{A,proxy.leftType}(proxy.length, actor)
# end

# # Observable
# struct SmaActor{A,L} <: Actor{L}
#     length::Int64
#     lastN::Vector{Union{Missing,L}}
#     next::A
# end
# SmaActor{A,L}(length::Int64, actor::A) where {A,L} = SmaActor{A,L}(length, Vector{Union{Missing,L}}(missing, length), actor)
# function Rocket.on_next!(actor::SmaActor, data::L) where {L}
#     circshift!(actor.lastN, -1)
#     actor.lastN[lastindex(actor.lastN)] = data
#     next!(actor.next, rightType(actor.length, L)(Statistics.mean(actor.lastN)))
# end

# Rocket.on_error!(actor::SmaActor, error) = error!(actor.next, error)
# Rocket.on_complete!(actor::SmaActor) = complete!(actor.next)