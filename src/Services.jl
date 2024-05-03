module Services

export service

@inline service(s::Symbol) = service(Val(s))

end