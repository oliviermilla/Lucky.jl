module Units

export Unit, Currency

abstract type Unit end

struct Currency <: Unit
    #name::String{24}
    threeLettersCode::String
end

Base.show(io::IO, c::Currency) = print(io, "$(c.threeLettersCode)")

end