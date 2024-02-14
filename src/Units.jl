module Units

export Unit, UnitType, TimestampType

using Dates

abstract type Unit end

UnitType(I::Type{<:Unit}) = I

include("units/Currencies.jl")

TimestampType(::Type{T}) where {T<:Any} = error("You probably forgot to implement TimestampType(::$(T))")
TimestampType(::Type{T}) where {T<:Dates.AbstractTime} = T
TimestampType(::Type{<:AbstractArray{E}}) where {E} = TimestampType(E)
TimestampType(::AbstractArray{E}) where {E} = TimestampType(E)

end