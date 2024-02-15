export rolling

rolling(n::Int) = RollingOperator(n)
struct RollingOperator <: InferableOperator
    length::Int
    function RollingOperator(length::Int)
        length > 0 || error("RollingOperator: $(length) must be positive.")
        return new(length)
    end
end
Rocket.operator_right(::RollingOperator, ::Type{L}) where {L} = Vector{Union{Missing, L}}

function trailFn(val::Int, vec::Vector)
    circshift!(vec, -1)
    vec[end] = val
    return vec
end

function Rocket.on_call!(::Type{L}, ::Type{R}, operator::RollingOperator, source) where {L,R}
    return proxy(R, source, Rocket.ScanProxy{L, R, Function}(trailFn, Vector{Union{Missing, L}}(missing, operator.length)))    
end
