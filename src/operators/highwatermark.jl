export highwatermark

highwatermark() = HighWaterMarkOperator()

struct HighWaterMarkOperator <: InferableOperator end

Rocket.operator_right(::HighWaterMarkOperator, ::Type{L}) where {L<:Any} = IndicatorType(HighWaterMarkIndicator, L)

function highwatermarkFn(val, indic::HighWaterMarkIndicator)
    if ismissing(indic.value) || val > indic.value
        indic.value = val
        return indic
    end
    return indic
end

function Rocket.on_call!(::Type{L}, ::Type{R}, operator::HighWaterMarkOperator, source) where {L,R}        
    return proxy(R, source, Rocket.ScanProxy{L, R, Function}(highwatermarkFn, R(missing)))
end