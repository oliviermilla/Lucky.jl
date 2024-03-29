export ema

ema(n::Int) = rolling(n) |> EmaOperator(n)

struct EmaOperator <: InferableOperator
    length::Int
end
Rocket.operator_right(op::EmaOperator, ::Type{L}) where {L<:Any} = IndicatorType(EMAIndicator, op.length, L)
Rocket.operator_right(op::EmaOperator, ::Type{<:IterableIndicator{V}}) where {V} = IndicatorType(EMAIndicator, op.length, V)

# https://www.tradingview.com/scripts/ema/?solution=43000502589
function emaFn(rolling, indic::EMAIndicator)
    if ismissing(indic.value)
        indic.value = smaFn(rolling)
        return indic
    end
    mult = 2 / (period(indic) + 1)
    indic.value += (rolling[end] - indic.value) * mult
    return indic
end

function Rocket.on_call!(::Type{L}, ::Type{R}, operator::EmaOperator, source) where {L,R}        
    return proxy(R, source, Rocket.ScanProxy{L, R, Function}(emaFn, R(missing)))
end