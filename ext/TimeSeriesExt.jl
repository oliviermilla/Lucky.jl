module TimeSeriesExt

using Lucky

import Rocket
import TimeSeries

Lucky.Ohlc(data::TimeSeries.TimeArray, index::Int) = Ohlc(
    TimeSeries.values(data[index][:Open])[1],
    TimeSeries.values(data[index][:High])[1],
    TimeSeries.values(data[index][:Low])[1],
    TimeSeries.values(data[index][:Close])[1],
    TimeSeries.timestamp(data[index])[1])

function Base.Vector{Ohlc}(data::T) where {T<:TimeSeries.TimeArray}
    vec = Vector{Lucky.Ohlc}()
    for i in 1:lastindex(data)
        ohlc = Lucky.Ohlc(data, i)
        push!(vec, ohlc)
    end
    return vec
end

Rocket.from(data::TimeSeries.TimeArray) = Rocket.from(Vector{Ohlc}(data))

end