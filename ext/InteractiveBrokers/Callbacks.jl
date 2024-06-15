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
    # TODO ???
    println("NextValidId: $orderId")
end

function tickPrice(ib::InteractiveBrokersObservable, tickerId::Int, field::String, price::Union{Float64,Nothing}, size::Union{Float64,Nothing}, attrib::InteractiveBrokers.TickAttrib)
    # data received: 1 DELAYED_BID -1.0
    mapping = ib.requestMappings[Pair(tickerId, :tickPrice)]
    subject = mapping[2]
    next!(subject, field)    
end

function tickString(ib::InteractiveBrokersObservable, tickerId::Int, tickType::String, value::String)
    # data received: 1 DELAYED_LAST_TIMESTAMP 1718409598
    # TODO Dispatch
    # TODO Merge with tickPrice Data !!!!
    println(tickerId, tickType, value)
end