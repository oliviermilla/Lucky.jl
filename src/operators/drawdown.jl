export drawdown

drawdown() = DrawdownOperator()

struct DrawdownOperator <: InferableOperator end

Rocket.operator_right(::DrawdownOperator, ::Type{L}) where {L} = IndicatorType(DrawdownIndicator, L)

function ddFn(val, indic::DrawdownIndicator{U,V}) where {U,V}
    # Same as the highwatermark() operator logic
    if ismissing(indic.highwatermark) || val > indic.highwatermark
        indic.highwatermark = val
        indic.value = zero(V)
        return indic
    end
    indic.value = val - indic.highwatermark
    return indic
end

function Rocket.on_call!(::Type{L}, ::Type{R}, operator::DrawdownOperator, source) where {L,R}
    return proxy(R, source, Rocket.ScanProxy{L,R,Function}(ddFn, R(missing, missing)))
end