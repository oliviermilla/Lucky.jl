struct Percent{N} <: Unit
    v::N
end

Base.show(io::IO, p::Percent) = return "$(p * 100)%"