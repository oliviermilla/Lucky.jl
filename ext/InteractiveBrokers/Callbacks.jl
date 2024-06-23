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

function tickPrice(ib::InteractiveBrokersObservable, tickerId::Int, field::String, price::Union{Float64,Nothing}, size::Union{Float64,Nothing}, attrib::InteractiveBrokers.TickAttrib)
    # TODO use attrib
    # ex data: 1 DELAYED_BID -1.0
    mapping = ib.requestMappings[Pair(tickerId, :tickPrice)]
    qte = Lucky.PriceQuote(mapping[3], price, nothing)
    next!(mapping[2], qte)
end

function tickSize(ib::InteractiveBrokersObservable, tickerId::Int, field::String, size::Float64)
    #TODO Use & dispatch
end

function tickString(ib::InteractiveBrokersObservable, tickerId::Int, field::String, value::String)
    # ex data: 1 DELAYED_LAST_TIMESTAMP 1718409598
    mapping = ib.requestMappings[Pair(tickerId, :tickString)]
    next!(mapping[2], unix2datetime(parse(Int64,value))) # TODO Handle timezones
end