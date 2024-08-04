export Future

"""
    Future

Instrument representing a Future.
"""
struct Future{S,C} <: Instrument 
    expiration::Date
end

Future(S::Symbol, C::Type{<:Currency}, expiration::Date) = Future{S,C}(expiration)
Future(S::Symbol, C::Union{Symbol, AbstractString}, expiration::Date) = Future{S,CurrencyType(C)}(expiration)

currency(::Future{S,C}) where {S,C} = CurrencyType(C)