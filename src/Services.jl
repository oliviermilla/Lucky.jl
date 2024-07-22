export service

function service end
@inline service(s::Symbol) = service(Val(s))