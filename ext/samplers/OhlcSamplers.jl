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
    open = previous.close + rand(rng, -2.00:0.01:2.00)
    high = open + rand(rng, 0.00:0.01:2.00)
    low  = open + rand(rng, -2.00:0.01:0.00)
    maxrng = high - low
    return Ohlc{T}(
        open,
        high,
        low,
        open + rand(rng, -maxrng:0.01:maxrng), # close
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