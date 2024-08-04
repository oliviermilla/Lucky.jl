# [Interactive Brokers](@id ibkr)


The [IBKR API](https://ibkrcampus.com/ibkr-api-page/ibkr-api-home/) is designed to efficiently serve the official clients (ibgatway, TWS, web). SDK (including InteractiveBrokers.jl) respect that structure. Integrations with Lucky.jl takes the utmost care to provide a more standard ('REST' type) approach.

```@docs
    Lucky.service(::Val{:interactivebrokers}; host=nothing, port::Int=4001, clientId::Int=1, connectOptions::String="", optionalCapabilities::String="")
    Lucky.trades(client::InteractiveBrokersObservable, instr::Instrument)
    Lucky.positions(client::InteractiveBrokersObservable)
```


