module Utils

function percentage(num::Number; rounded::Union{Nothing,Int}=nothing, humanreadable::Bool=false)
    if (humanreadable)
        isnothing(rounded) && return "$(num * 100)%"        
        return "$(round(num * 100,digits=rounded))%"        
    end

    isnothing(rounded) && return num    
    return round(num; digits=rounded)
end

end