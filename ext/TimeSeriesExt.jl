module TimeSeriesExt

using Lucky

import Rocket
import TimeSeries
using Dates

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

function Lucky.quotes(instr::Instrument, data::TimeSeries.TimeArray)
    instrType = InstrumentType(instr)
    rightType = QuoteType(instrType, Ohlc{Date})
    return Rocket.from(data) |> map(rightType, ohlc -> Quote(instr, ohlc))
end
end