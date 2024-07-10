module InteractiveBrokersExt

using InteractiveBrokers
using Lucky
using Rocket
using Dates

struct CallbackKey
    requestId::Int
    callbackSymbol::Symbol
    tickType::InteractiveBrokers.TickTypes.TICK_TYPES
end

struct CallbackValue
    callbackFunction::Function
    subject::Rocket.Subject
    instrument::Lucky.Instrument
end

const CallbackMapping = Dict{CallbackKey,CallbackValue}

mutable struct InteractiveBrokersObservable <: Subscribable{Nothing}
    requestMappings::CallbackMapping
    mergedCallbacks::Dict{Symbol,Rocket.Subscribable}

    nextValidId::Union{Missing,Int}

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
        ib = new(
            CallbackMapping(),
            Dict{Symbol,Rocket.Subscribable}(),
            missing,
            host,
            port,
            clientId,
            connectOptions,
            optionalCapabilities,
            nothing,
            nothing,
            nothing,
            Vector{Function}()
        )
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

#= 

Actually, Lucky.feed() should specify what is being fed. Orderbook data? trade data? stats? others?
So the idea is to map request options to type of feed and return observables for each type.
An idea could be to create generic data types (ex: orderbook, trade, etc.) and map to that. Use polygon API for instance.
As a first step, define orderbook, quote and trade types and flag the rest as un supported.

call feed() for each type of data and instrument
keep a mapping of all data with expected output Observable
merge all request into a reqMktData with all the options
Use that in Callbacks

OrderBook fields
BID_SIZE = 0
BID = 1
ASK = 2
ASK_SIZE = 3

Trade fields
LAST = feed()
LAST_SIZE = feed()

Today stats
HIGH = 6
LOW = 7
VOLUME = 8

Yesterday's close
CLOSE = 9

Option Greeks
BID_OPTION = 10
ASK_OPTION = 11
LAST_OPTION = 12
MODEL_OPTION = 13

Today Open
OPEN = 14

Historical Stats (request code 165)
LOW_13_WEEK = 15
HIGH_13_WEEK = 16
LOW_26_WEEK = 17
HIGH_26_WEEK = 18
LOW_52_WEEK = 19
HIGH_52_WEEK = 20
AVG_VOLUME = 21
OPEN_INTEREST = 22

Option realized an implied vol (request code 104 & 106)
OPTION_HISTORICAL_VOL = 23
OPTION_IMPLIED_VOL = 24

Unused
OPTION_BID_EXCH = 25
OPTION_ASK_EXCH = 26

OPTION_CALL_OPEN_INTEREST = 27
OPTION_PUT_OPEN_INTEREST = 28
OPTION_CALL_VOLUME = 29
OPTION_PUT_VOLUME = 30
INDEX_FUTURE_PREMIUM = 31
BID_EXCH = 32
ASK_EXCH = 33
AUCTION_VOLUME = 34
AUCTION_PRICE = 35
AUCTION_IMBALANCE = 36
MARK_PRICE = 37
BID_EFP_COMPUTATION = 38
ASK_EFP_COMPUTATION = 39
LAST_EFP_COMPUTATION = 40
OPEN_EFP_COMPUTATION = 41
HIGH_EFP_COMPUTATION = 42
LOW_EFP_COMPUTATION = 43
CLOSE_EFP_COMPUTATION = 44
LAST_TIMESTAMP = feed()
SHORTABLE = 46
FUNDAMENTAL_RATIOS = 47
RT_VOLUME = 48
HALTED = 49
BID_YIELD = 50
ASK_YIELD = 51
LAST_YIELD = 52
CUST_OPTION_COMPUTATION = 53
TRADE_COUNT = 54
TRADE_RATE = 55
VOLUME_RATE = 56
LAST_RTH_TRADE = 57
RT_HISTORICAL_VOL = 58
IB_DIVIDENDS = 59
BOND_FACTOR_MULTIPLIER = 60
REGULATORY_IMBALANCE = 61
NEWS_TICK = 62
SHORT_TERM_VOLUME_3_MIN = 63
SHORT_TERM_VOLUME_5_MIN = 64
SHORT_TERM_VOLUME_10_MIN = 65
DELAYED_BID = 66
DELAYED_ASK = 67
DELAYED_LAST = feed()
DELAYED_BID_SIZE = 69
DELAYED_ASK_SIZE = 70
DELAYED_LAST_SIZE = feed()
DELAYED_HIGH = 72
DELAYED_LOW = 73
DELAYED_VOLUME = 74
DELAYED_CLOSE = 75
DELAYED_OPEN = 76
RT_TRD_VOLUME = 77
CREDITMAN_MARK_PRICE = 78
CREDITMAN_SLOW_MARK_PRICE = 79
DELAYED_BID_OPTION = 80
DELAYED_ASK_OPTION = 81
DELAYED_LAST_OPTION = 82
DELAYED_MODEL_OPTION = 83
LAST_EXCH = 84
LAST_REG_TIME = 85
FUTURES_OPEN_INTEREST = 86
AVG_OPT_VOLUME = 87
DELAYED_LAST_TIMESTAMP = feed()
SHORTABLE_SHARES = 89
DELAYED_HALTED = 90
REUTERS_2_MUTUAL_FUNDS = 91
ETF_NAV_CLOSE = 92
ETF_NAV_PRIOR_CLOSE = 93
ETF_NAV_BID = 94
ETF_NAV_ASK = 95
ETF_NAV_LAST = 96
ETF_FROZEN_NAV_LAST = 97
ETF_NAV_HIGH = 98
ETF_NAV_LOW = 99
SOCIAL_MARKET_ANALYTICS = 100
ESTIMATED_IPO_MIDPOINT = 101
FINAL_IPO_LAST = 102
DELAYED_YIELD_BID = 103
DELAYED_YIELD_ASK = 104 
=#

feedMerge(tup::Tuple{Lucky.AbstractTrade,Float64,DateTime}) = Trade(tup[1].instrument, tup[1].price, tup[2], tup[3])

function Lucky.feed(client::InteractiveBrokersObservable, instr::Instrument)
    requestId = nextValidId(client)

    InteractiveBrokers.reqMktData(client, requestId, instr, "", false)

    tickPriceSubject = Subject(Lucky.PriceQuote)
    tickSizeSubject = Subject(Pair)
    tickStringSubject = Subject(DateTime)

    client.requestMappings[CallbackKey(requestId, :tickPrice, InteractiveBrokers.TickTypes.LAST)] = CallbackValue(tickPrice, tickPriceSubject, instr)
    client.requestMappings[CallbackKey(requestId, :tickPrice, InteractiveBrokers.TickTypes.DELAYED_LAST)] = CallbackValue(tickPrice, tickPriceSubject, instr)
    client.requestMappings[CallbackKey(requestId, :tickSize, InteractiveBrokers.TickTypes.LAST_SIZE)] = CallbackValue(tickSize, tickSizeSubject, instr)
    client.requestMappings[CallbackKey(requestId, :tickSize, InteractiveBrokers.TickTypes.DELAYED_LAST_SIZE)] = CallbackValue(tickSize, tickSizeSubject, instr)
    client.requestMappings[CallbackKey(requestId, :tickString, InteractiveBrokers.TickTypes.DELAYED_LAST_TIMESTAMP)] = CallbackValue(tickString, tickStringSubject, instr)
    client.requestMappings[CallbackKey(requestId, :tickString, InteractiveBrokers.TickTypes.DELAYED_LAST_TIMESTAMP)] = CallbackValue(tickString, tickStringSubject, instr)

    merged = Rocket.combineLatest(tickPriceSubject, tickSizeSubject, tickStringSubject) |> Rocket.map(Lucky.PriceQuote, feedMerge)

    # Output callback
    client.mergedCallbacks[:tick] = merged

    # subscribe!(client.obs, tickPriceSubject)
    # subscribe!(client.obs, tickStringSubject)

    return merged
end

function nextValidId(ib::InteractiveBrokersObservable)
    if ismissing(ib.nextValidId)
        ib.nextValidId = 0
    end
    return ib.nextValidId += 1
end

function wrapper(client::InteractiveBrokersObservable)
    wrap = InteractiveBrokers.Wrapper(client)

    # Mandatory callbacks
    setproperty!(wrap, :error, error)
    setproperty!(wrap, :managedAccounts, managedAccounts)
    setproperty!(wrap, :nextValidId, nextValidId)

    for (key, val) in client.requestMappings
        setproperty!(wrap, key.callbackSymbol, val.callbackFunction)
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