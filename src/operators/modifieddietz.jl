
# # https://blog.yomoni.fr/comment-est-calculee-la-performance-chez-yomoni/
# function modifieddietz(history::Vector{DydxV3.HistoricalPnl};
#     annualized::Bool=false,
#     period::Union{Nothing,Type{T}}=nothing,
#     rounded::Union{Nothing,Int}=nothing,
#     humanreadable::Bool=false
# ) where {T<:Period}

#     valtype = humanreadable ? String : Float64

#     dates = Vector{Date}()
#     data = Vector{valtype}()

#     if (isnothing(period))
#         push!(dates, Date(history[lastindex(history)].createdAt))
#         push!(data, modifieddietz(history, firstindex(history), lastindex(history); annualized=annualized, rounded=rounded, humanreadable=humanreadable))
#         return TimeArray((date = dates, data = data), timestamp = :date)
#     end

#     if (!(period in [Year, Quarter, Month, Week, Day]))
#         raise(ArgumentError("Unsupported Period: $(period)"))
#     end

#     calculatekey = hist -> Date(trunc(hist.createdAt, period) + period(1) - Day(1))

#     firstidx = firstindex(history)
#     currentkey = calculatekey(history[firstidx])

#     idx = firstidx + 1
#     while idx <= lastindex(history)
#         k = calculatekey(history[idx])
#         if (k != currentkey)
#             push!(dates, currentkey)
#             push!(data, modifieddietz(history, firstidx, idx - 1; annualized=annualized, rounded=rounded, humanreadable=humanreadable))
#             firstidx = idx
#             currentkey = k
#         elseif (idx == lastindex(history))
#             push!(dates, currentkey)
#             push!(data, modifieddietz(history, firstidx, idx; annualized=annualized, rounded=rounded, humanreadable=humanreadable))
#             break
#         else
#             idx += 1
#         end
#     end
#     return TimeArray((date = dates, data = data), timestamp = :date)
# end

# # Does not work if initial transfers at index 1 are zero.
# # Either pass a subset of the history vector starting with firstindex > 1
# # Or the entire serie that should have the initial transfers included.
# function modifieddietz(history::Vector{DydxV3.HistoricalPnl}, firstindex::Int, lastindex::Int;
#     annualized::Bool=false,
#     rounded::Union{Nothing,Int}=nothing,
#     humanreadable::Bool=false
# )
#     #println("dietz firstindex: $(firstindex). lastindex: $(lastindex)")

#     if (firstindex == lastindex && firstindex == Base.firstindex(history))
#         return 0.0
#     end

#     last = Date(history[lastindex].createdAt)
#     pnl = history[lastindex].equity
#     weight = 0.0

#     period = nothing

#     if (firstindex > Base.firstindex(history))
#         # Consider the period from the previous equity date
#         previous = history[firstindex-1]
#         period = float(Dates.value(Day(last - Date(previous.createdAt))))
#         # Consider previous equity as a first transfer
#         previousequity = previous.equity

#         pnl -= previousequity
#         weight += modifieddietzweight(previousequity, Date(history[firstindex-1].createdAt), last, period)
#         #println("Initial weight: $(weight)")
#     else
#         period = float(Dates.value(Day(last - Date(history[firstindex].createdAt))))
#     end

#     for idx in firstindex:lastindex
#         transfer = history[idx].netTransfers
#         if (abs(transfer) > 0.001)
#             pnl -= transfer
#             weight += modifieddietzweight(transfer, Date(history[idx].createdAt), last, period)
#         end
#     end
#     #println("Final weight: $(weight)")

#     perf = pnl / weight
#     if (annualized)
#         perf = perf * 365 / period
#     end

#     return formatresult(perf; rounded=rounded, humanreadable=humanreadable)
# end

# @inline function modifieddietzweight(transfer::Number, first::Date, last::Date, period::Float64)
#     return transfer * float(Dates.value(Day(last - first))) / period
# end