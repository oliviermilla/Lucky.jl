export drawdown

drawdown() = with_latest(highwatermark()) |> DrawdownOperator()

struct DrawdownOperator <: InferableOperator end

Rocket.operator_right(::DrawdownOperator, ::Type{L}) where {L} = IndicatorType(DrawdownIndicator, L)

function ddFn(mark, indic::DrawdownIndicator{U,V}) where {U,V}
    
    if ismissing(indic.value)
        indic.value = zero(V)
        return indic
    end

    if mark.value < indic.value
        indic.value = val.value
        return indic
    end

    return indic
end

function Rocket.on_call!(::Type{L}, ::Type{R}, operator::DrawdownOperator, source) where {L,R}
    return proxy(R, source, Rocket.ScanProxy{L,R,Function}(ddFn, R(missing)))
end