module Units

export Unit, UnitType, TimestampType

using Dates

"""
    Unit

Abstract Unit type.
A Unit describes the exchanged quantities.

# Examples
- 1 USD
- 1 OUNCE
- 1 LOT
- 1 BARREL

See also: [`Currencies`](@ref)
"""
abstract type Unit end

UnitType(I::Type{<:Unit}) = I

include("units/Currencies.jl")
using .Currencies
export Currency, CurrencyType
export symbol, currency

TimestampType(::Type{T}) where {T<:Any} = error("You probably forgot to implement TimestampType(::$(T))")
TimestampType(::Type{T}) where {T<:Dates.AbstractTime} = T
TimestampType(::Type{<:AbstractArray{E}}) where {E} = TimestampType(E)
TimestampType(::AbstractArray{E}) where {E} = TimestampType(E)

end