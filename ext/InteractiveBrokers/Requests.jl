@inline function delayedReq(fn::Function, ib::InteractiveBrokersObservable)
    if isnothing(ib.connection)
        pushfirst!(ib.pendingCmds, fn)
        return nothing
    end
    fn(ib.connection)
    return nothing
end

function nextValidId(ib::InteractiveBrokersObservable)
    if ismissing(ib.nextValidId)
        ib.nextValidId = 0
    end
    return ib.nextValidId += 1
end

function InteractiveBrokers.reqIds(ib::InteractiveBrokersObservable)
    f = (connection) -> InteractiveBrokers.reqIds(connection)
    delayedReq(f, ib)
end

function InteractiveBrokers.reqMktData(ib::InteractiveBrokersObservable, reqId::Int, instr::Instrument, genericTicks::String, snapshot::Bool, regulatorySnaphsot::Bool=false, mktDataOptions::NamedTuple=(;))
    f = (connection) -> InteractiveBrokers.reqMktData(connection, reqId, InteractiveBrokers.Contract(instr), genericTicks, snapshot, regulatorySnaphsot, mktDataOptions)
    delayedReq(f, ib)
end

function InteractiveBrokers.reqMarketDataType(ib::InteractiveBrokersObservable, t::InteractiveBrokers.MarketDataType)
    f = (connection) -> InteractiveBrokers.reqMarketDataType(connection, t)
    delayedReq(f, ib)
end

function InteractiveBrokers.reqPositions(ib::InteractiveBrokersObservable)
    f = (connection) -> InteractiveBrokers.reqPositions(connection)
    delayedReq(f, ib)
end