export UnitType

"""
    Unit

Abstract Unit type.

A Unit describes a quantity.

# Examples
- 1 USD
- 1 OUNCE
- 1 LOT
- 1 BARREL

See also: [`Currency`](@ref currencies)
"""
abstract type Unit end

UnitType(I::Type{<:Unit}) = I