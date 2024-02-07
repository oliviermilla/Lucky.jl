module Performances

export drawdown

function drawdown(equity::Vector{F}; rounded::Union{Nothing,Int}=nothing, humanreadable::Bool=false) where {F<:Number}
    len = length(equity)
    res = zeros(F, length(equity))
    len < 2 && return res
    high = equity[firstindex(equity)]
    for (idx, eq) in Iterators.enumerate(equity)
        if (eq > high)
            high = eq
            continue
        end
        res[idx] = percentage(F(1) - eq / high; rounded, humanreadable)
    end
    return res
end

function percentage(num::Number; rounded::Union{Nothing,Int}=nothing, humanreadable::Bool=false)
    if (humanreadable)
        isnothing(rounded) && return "$(num * 100)%"        
        return "$(round(num * 100,digits=rounded))%"        
    end

    isnothing(rounded) && return num    
    return round(num; digits=rounded)
end

end