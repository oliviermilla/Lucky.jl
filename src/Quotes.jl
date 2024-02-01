module Quotes

export Quote
export currency, timestamp

using Lucky.Ohlcs
import Lucky.Units as Units

struct Quote{I,Q}
    instrument::I
    price::Q
end

Units.currency(q::Quote) = Units.currency(q.instrument)
timestamp(q::Quote{I,Q}) where {I,Q<:Ohlc} = q.price.timestamp

end