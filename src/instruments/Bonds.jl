export Bond

"""
    Bond

Instrument representing a bond.
"""
struct Bond{S,C} <: Instrument 
    maturity::Date
end

Bond(S::Symbol, C::Type{<:Currency}, maturity::Date) = Bond{S,C}(maturity)
Bond(S::Symbol, C::Union{Symbol, AbstractString}, maturity::Date) = Bond{S,CurrencyType(C)}(maturity)

currency(::Bond{S,C}) where {S,C} = CurrencyType(C)