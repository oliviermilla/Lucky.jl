export rolling

rolling(n::Int) = RollingOperator(n)

struct RollingOperator <: InferableOperator
    length::Int
    function RollingOperator(length::Int)
        length > 0 || error("RollingOperator: $(length) must be positive.")
        return new(length)
    end
end
Rocket.operator_right(op::RollingOperator, ::Type{L}) where {L} = IndicatorType(RollingIndicator, op.length, L)

function trailFn(val, indic::RollingIndicator)
    circshift!(indic.value, -1)
    indic.value[end] = val
    return indic
end

function Rocket.on_call!(::Type{L}, ::Type{R}, op::RollingOperator, source) where {L,R}
    return proxy(R, source, Rocket.ScanProxy{L, R, Function}(trailFn, R(Vector{Union{Missing, L}}(missing, op.length))))
end
