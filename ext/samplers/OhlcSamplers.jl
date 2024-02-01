module OhlcSamplers

using Lucky.Ohlcs
using Dates
using Random

function Random.rand(rng::Random.AbstractRNG, ::Type{Ohlc{DateTime}})
    return Ohlc{DateTime}(
        rand(rng, 100:0.1:110),
        rand(rng, 110:0.1:150),
        rand(rng, 80:0.1:100),
        rand(rng, 80:0.1:150),
        rand(rng, DateTime(2000, 1, 1):Second(1):DateTime(2010, 12, 31))
    )
end

function Random.rand(rng::Random.AbstractRNG, ::Type{Ohlc{Date}})
    return Ohlc{Date}(
        rand(rng, 100:0.1:110),
        rand(rng, 110:0.1:150),
        rand(rng, 80:0.1:100),
        rand(rng, 80:0.1:150),
        rand(rng, Date(2000, 1, 1):Day(1):Date(2010, 12, 31))
    )
end

function Random.rand(rng::AbstractRNG, previous::Ohlc{T}, period::Dates.Period) where {T}
    return Ohlc{T}(
        previous.open + rand(rng, -2.00:0.01:2.00),
        previous.high + rand(rng, -2.00:0.01:2.00),
        previous.low + rand(rng, -2.00:0.01:2.00),
        previous.close + rand(rng, -2.00:0.01:2.00),
        previous.timestamp + period
    )
end

function Random.rand(rng::AbstractRNG, type::Type{Ohlc{T}}, period::Dates.Period, n::Int) where {T}
    res = Vector{Ohlc{T}}()
    push!(res, rand(rng, type))
    n == 1 && return res
    for i in 2:n
        push!(res, rand(rng, res[end], period))
    end
    return res
end

Random.rand(d::Type{Ohlc{T}}, period::Dates.Period, n::Int) where {T} = rand(Random.default_rng(), d, period, n)

end