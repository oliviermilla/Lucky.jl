export timestamp
export TimestampType

"""
    timestamp

    Returns the timestamp of the object.    
"""
timestamp(::Type{T}) where {T} = error("You probably forgot to implement timestamp(::$(T))")

TimestampType(::Type{T}) where {T<:Any} = error("You probably forgot to implement TimestampType(::$(T))")
TimestampType(::Type{T}) where {T<:Dates.AbstractTime} = T
TimestampType(::Type{<:AbstractArray{E}}) where {E} = TimestampType(E)
TimestampType(::AbstractArray{E}) where {E} = TimestampType(E)