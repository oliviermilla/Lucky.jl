module Utils

function percentage(num::Number; rounded::Union{Nothing,Int}=nothing, humanreadable::Bool=false)
    if (humanreadable)
        isnothing(rounded) && return "$(num * 100)%"        
        return "$(round(num;digits=rounded) * 100)%"
    end

    isnothing(rounded) && return num    
    return round(num; digits=rounded)
end

end