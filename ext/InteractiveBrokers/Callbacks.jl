function error(ib::InteractiveBrokersObservable, err::InteractiveBrokers.IbkrErrorMessage)
    if (err.id == -1)
        @info "Skipped Message: $(err)"
        return
    end

    println("error! $(err)")
    #Rocket.error!(ib, err)
end

function managedAccounts(ib::InteractiveBrokersObservable, accountsList::String)
    accounts = split(accountsList, ",")
    filter!(x -> !isempty(x), accounts)
    # TODO Dispatch
    #println("Accounts: $(accounts)")
end

function nextValidId(ib::InteractiveBrokersObservable, orderId::Int)
    ib.nextValidId = orderId
end

function tickPrice(ib::InteractiveBrokersObservable, tickerId::Int, field::InteractiveBrokers.TICK_TYPES, price::Union{Float64,Nothing}, size::Union{Float64,Nothing}, attrib::InteractiveBrokers.TickAttrib)
    # ex data: 1 DELAYED_BID -1.0
    # TODO use attrib
    key = CallbackKey(tickerId, :tickPrice, field)
    if haskey(ib.requestMappings, key)
        val = ib.requestMappings[key]
        qte = Lucky.Quote(val.instrument, price, nothing)
        next!(val.subject, qte)
    end
end

function tickSize(ib::InteractiveBrokersObservable, tickerId::Int, field::InteractiveBrokers.TICK_TYPES, size::Float64)
    key = CallbackKey(tickerId, :tickSize, field)
    if haskey(ib.requestMappings, key)
        val = ib.requestMappings[key]
        next!(val.subject, size)
    end
end

function tickString(ib::InteractiveBrokersObservable, tickerId::Int, field::InteractiveBrokers.TICK_TYPES, value::String)
    # ex data: 1 DELAYED_LAST_TIMESTAMP 1718409598
    key = CallbackKey(tickerId, :tickString, field)
    if haskey(ib.requestMappings, key)
        val = ib.requestMappings[key]
        # TODO Handle timezones
        next!(val.subject, unix2datetime(parse(Int64, value)))
    end
end