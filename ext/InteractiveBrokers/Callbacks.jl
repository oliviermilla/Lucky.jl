function error(ib::InteractiveBrokersObservable, err::InteractiveBrokers.IbkrErrorMessage)
    if (err.id == -1)
        @debug "Skipped Message: $(err)"
        return
    end

    println("error! $(err)")
    #Rocket.error!(ib, err)
end

@inline function dispatchTrades(func::Function, ib::InteractiveBrokersObservable, reqId::Int, fn::Symbol, field::Any)
    key = CallbackTradesKey(reqId, fn, field)
    if haskey(ib.requestTradesMappings, key)
        val = ib.requestTradesMappings[key]
        data = func(val)
        next!(val.subject, data)
    end
end

# @inline function dispatchAccounts(func::Function, ib::InteractiveBrokersObservable, fn::Symbol)

@inline function dispatchPositions(func::Function, ib::InteractiveBrokersObservable, fn::Symbol)
    key = CallbackPositionsKey(fn)
    if haskey(ib.requestPositionsMappings, key)
        val = ib.requestPositionsMappings[key]
        data = func(val)
        @debug data
        next!(val.subject, data)
    end
end

function managedAccounts(ib::InteractiveBrokersObservable, accountsList::String)
    @debug "managedAccounts" accountsList
    
    # dispatchTrades(ib, :managedAccounts, nothing) do val
    #     accounts = split(accountsList, ",")
    #     filter!(x -> !isempty(x), accounts)        
    # end    
end

function marketDataType(ib::InteractiveBrokersObservable, reqId::Int, marketDataType::InteractiveBrokers.MarketDataType)
    @debug "marketDataType" reqId marketDataType
end

function nextValidId(ib::InteractiveBrokersObservable, orderId::Int)
    ib.nextValidId = orderId
end

function position(ib::InteractiveBrokersObservable, account::String, contract::InteractiveBrokers.Contract, position::Float64, avgCost::Float64)
    @debug "position" account contract position avgCost
    dispatchPositions(ib, :position) do val        
        IbKrPosition(
            account,
            Lucky.Instrument(contract),
            position,
            avgCost,
            now() # TODO handle TimeZones
        )
    end
end

function positionEnd(ib::InteractiveBrokersObservable)
    @debug "positionEnd"
    # Do Nothing
end

function tickPrice(ib::InteractiveBrokersObservable, tickerId::Int, field::InteractiveBrokers.TickTypes.TICK_TYPES, price::Union{Float64,Nothing}, size::Union{Float64,Nothing}, attrib::InteractiveBrokers.TickAttrib)
    @debug "tickPrice" tickerId field price size attrib
    # ex data: 1 DELAYED_BID -1.0
    # TODO use attrib
    dispatchTrades(ib, tickerId, :tickPrice, field) do val
        Lucky.Trade(val.instrument, price, size)
    end
end

function tickReqParams(ib::InteractiveBrokersObservable, tickerId::Int, minTick::Union{Float64,Nothing}, bboExchange::String, snapshotPermissions::Int)
    @debug "tickReqParams" tickerId minTick bboExchange snapshotPermissions
end

function tickSize(ib::InteractiveBrokersObservable, tickerId::Int, field::InteractiveBrokers.TickTypes.TICK_TYPES, size::Float64)
    @debug "tickSize" tickerId field size
    # ex data: 1 DELAYED_VOLUME 0.0

    # Commented out: See comment in trades()
    # dispatchTrades(ib, tickerId, :tickSize, field) do val
    #     size
    # end
end

function tickString(ib::InteractiveBrokersObservable, tickerId::Int, field::InteractiveBrokers.TickTypes.TICK_TYPES, value::String)
    @debug tickString tickerId field value
    # ex data: 1 DELAYED_LAST_TIMESTAMP 1718409598
    dispatchTrades(ib, tickerId, :tickString, field) do val
        # TODO Handle timezones
        unix2datetime(parse(Int64, value))
    end
end