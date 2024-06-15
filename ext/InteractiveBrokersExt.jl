module InteractiveBrokersExt


# c = client(:interactivebrokers) # Returns an observable with the connectable & count thing.
# function on_subscribe()
#     # set wrapper
#     # start client and set teardown.
# end
# feed(c, blahblah) # Returns an observable subscribed to c.
# exchange = broker(c) # returns an Exchange
# ledger = ledger(c)
# pos = feed(c, blahblah)
# subscribe(pos, ledger)

# connect(c)

using InteractiveBrokers
using Lucky
using Rocket

mutable struct InteractiveBrokersObservable <: Subscribable{Nothing}
    requestMappings::Dict{Pair{Int,Symbol},Tuple{Function,Rocket.Subject, Any}}

    host::Union{Nothing,Any} # IPAddr (not typed to avoid having to add Sockets to Project.toml 1.10)
    port::Union{Nothing,Int}

    clientId::Union{Nothing,Int}

    connectOptions::Union{Nothing,String}
    optionalCapabilities::Union{Nothing,String}

    connectable::Union{Nothing,Rocket.ConnectableObservable}
    obs::Union{Nothing,Rocket.Subscribable}

    connection::Union{Nothing,InteractiveBrokers.Connection}
    pendingCmds::Vector{Function}

    function InteractiveBrokersObservable(host=nothing, port::Union{Nothing,Int}=nothing, clientId::Union{Nothing,Int}=nothing, connectOptions::Union{Nothing,String}=nothing, optionalCapabilities::Union{Nothing,String}=nothing)
        ib = new(Dict{Pair{Int,Symbol},Tuple{Function,Rocket.Subject, Any}}(), host, port, clientId, connectOptions, optionalCapabilities, nothing, nothing, nothing, Vector{Function}())
        ib.connectable = ib |> publish()
        ib.obs = ib.connectable |> ref_count()
        return ib
    end
end

Rocket.connect(ibObservable::InteractiveBrokersObservable) = Rocket.connect(ibObservable.connectable)

struct InteractiveBrokersObservableSubscription <: Teardown
    connection::InteractiveBrokers.Connection
end

function Rocket.on_subscribe!(obs::InteractiveBrokersObservable, actor)
    fields = [:host, :port, :clientId, :connectOptions, :optionalCapabilities]
    # reduce the list to non nothing
    filter!(x -> !isnothing(getfield(obs, x)), fields)
    # map the list to their data
    values = map(x -> getfield(obs, x), fields)
    # build the NamedTuple
    params = (; zip(fields, values)...)

    obs.connection = InteractiveBrokers.connect(; params...)
    InteractiveBrokers.start_reader(obs.connection, wrapper(obs))
    # Send pending commands
    while !isempty(obs.pendingCmds)
        cmd = pop!(obs.pendingCmds)
        cmd(obs.connection)
    end

    return InteractiveBrokersObservableSubscription(obs.connection)
end

Rocket.as_teardown(::Type{<:InteractiveBrokersObservableSubscription}) = UnsubscribableTeardownLogic()

function Rocket.on_unsubscribe!(subscription::InteractiveBrokersObservableSubscription)
    disconnect(subscription.connection)
end

include("InteractiveBrokers/Requests.jl")
include("InteractiveBrokers/Callbacks.jl")

function Lucky.service(::Val{:interactivebrokers}; host=nothing, port::Int=4001, clientId::Int=1, connectOptions::String="", optionalCapabilities::String="")
    return InteractiveBrokersObservable(host, port, clientId, connectOptions, optionalCapabilities)
end

function Lucky.feed(client::InteractiveBrokersObservable, instr::Instrument, callback::Union{Nothing,Function}=nothing, outputType::Type=Any)
    # TODO default subject type depending on callback
    subject = Subject(outputType)

    #TODO Next Valid Id
    requestId = 1
    # TODO options
    InteractiveBrokers.reqMktData(client, requestId, instr, "", false)
    
    _callback::Function = identity    
    if isnothing(callback)
        # TODO callbacks depending on requested data
        _callback = tickPrice
    end
    client.requestMappings[Pair(requestId, :tickPrice)] = (_callback, subject, instr)
    # TODO Clean up 
    client.requestMappings[Pair(requestId, :tickString)] = (tickString, subject, instr)

    subscribe!(client.obs, subject)
    return subject
end

# function Lucky.feed(client::InteractiveBrokersObservable, event::Symbol)
#     haskey(defaultMapper, event) && return feed(client, event, defaultMapper[event][1], defaultMapper[event][2])
#     return faulted("No default mapping function for $(event). Provide one or contribute a default implementation.")
# end

function wrapper(client::InteractiveBrokersObservable)
    wrap = InteractiveBrokers.Wrapper(client)

    # Mandatory callbacks
    setproperty!(wrap, :error, error)
    setproperty!(wrap, :managedAccounts, managedAccounts)
    setproperty!(wrap, :nextValidId, nextValidId)

    for (pair,tuple) in client.requestMappings        
        setproperty!(wrap, pair.second, tuple[1])
    end
    return wrap
end

secType(::T) where {T<:Lucky.Instrument} = Base.error("You probably forgot to implement secType(::$(T))")
secType(::T) where {T<:Lucky.Cash} = "CASH"
secType(::T) where {T<:Lucky.Stock} = "STK"

symbol(::T) where {T<:Lucky.Instrument} = Base.error("You probably forgot to implement symbol(::$(T))")
symbol(::T) where {C,T<:Lucky.Cash{C}} = String(C)
symbol(::T) where {S,C,T<:Lucky.Stock{S,C}} = String(S)

exchange(::T) where {T<:Lucky.Instrument} = Base.error("You probably forgot to implement exchange(::$(T))")
exchange(::T) where {C,T<:Lucky.Cash{C}} = "IDEALPRO" # TODO: Support Virtual Forex
exchange(::T) where {S,C,T<:Lucky.Stock{S,C}} = "SMART"

function InteractiveBrokers.Contract(i::Lucky.Instrument)
    return InteractiveBrokers.Contract(
        symbol=symbol(i),
        secType=secType(i),
        exchange=exchange(i),
        currency=Lucky.Units.currency(i)
    )
end

end