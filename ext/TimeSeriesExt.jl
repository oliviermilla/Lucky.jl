module TimeSeriesExt

using Lucky

using TimeSeries

Lucky.Ohlc(data::TimeSeries.TimeArray, index::Int) = Ohlc(
    values(data[index][:Open])[1],
    values(data[index][:High])[1],
    values(data[index][:Low])[1],
    values(data[index][:Close])[1],
    timestamp(data[index])[1])

function Base.Vector{Ohlc}(data::T) where {T<:TimeSeries.TimeArray}
    vec = Vector{Lucky.Ohlc}()
    for i in 1:lastindex(data)
        ohlc = Lucky.Ohlc(data, i)
        push!(vec, ohlc)
    end
    return vec
end

end