module Services

export service

@inline service(s::Symbol) = service(Val(s))
service(::Val{T}) where {T} = error("You probably forgot to implement service(::Val{$(T)})")

end