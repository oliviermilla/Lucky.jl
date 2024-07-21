import Dates

TimestampType(::Type{T}) where {T<:Any} = error("You probably forgot to implement TimestampType(::$(T))")
TimestampType(::Type{T}) where {T<:Dates.AbstractTime} = T
TimestampType(::Type{<:AbstractArray{E}}) where {E} = TimestampType(E)
TimestampType(::AbstractArray{E}) where {E} = TimestampType(E)