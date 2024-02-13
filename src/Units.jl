module Units

export Unit, UnitType

abstract type Unit end

UnitType(I::Type{<:Unit}) = I

include("units/Currencies.jl")

end