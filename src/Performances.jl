module Performances

export drawdown

function drawdown(equity::Vector{F}) where {F<:Real}
    len = length(equity)
    res = zeros(F, length(equity))
    len < 2 && return res
    high = equity[firstindex(equity)]
    for (idx, eq) in Iterators.enumerate(equity)        
        if (eq > high)
            high = eq            
            continue
        end
        res[idx] = F(1) - eq / high
    end
    return res
end

end