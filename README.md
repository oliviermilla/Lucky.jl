# Lucky

[![Build Status](https://github.com/oliviermilla/Lucky.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/oliviermilla/Lucky.jl/actions/workflows/CI.yml?query=branch%3Amain)


Lucky is a trading framework for Julia.

It is built with the objectives of 

- rapidly deploying trading statregies to production.
- being fast to run.
- being modular to tailor and extend to different needs.

It relies on [Rocket.jl](https://github.com/ReactiveBayes/Rocket.jl) to be **asynchronous** and **reactive**.

Example code:
```julia
    using MarketData # to get historical quots from yahoo
    aapl = yahoo("AAPL") # Input data, could be anything, WebSocket, etc.

    quotes = Subject(Ohlc) # Open High Low Close feed
    source = Rocket.iterable(Vector{Ohlc}(aapl)) |> multicast(quotes)

    orders = Subject(Any) # Feed of all orders sent by our Strategy
    strategy = Strategy(orders) # This is yours to write, see below :)

    positions = Subject(Any) # Feed of all executed orders
    exchange = FakeExchange(positions) # Exchange for backtest purposes.

    subscribe!(positions, logger()) # log all positions
    subscribe!(orders, exchange) # exchange subscription's to orders
    subscribe!(source, exchange) # exchange subscription's to Ohlcs
    subscribe!(source, strategy) # strategy's subscription to incoming Ohlcs

    connect(source) # Let's roll!
```

What does a Strategy looks like?

```julia
struct Strategy <: AbstractStrategy    
    next::AbstractSubject
end

function Rocket.on_next!(str::Strategy, ohlc::Ohlc{Date})    
    # Do whatever you want, this gets called every time a new Ohlc is received.

    order = MarketOrder(1) # Let's buy 1 contract

    next!(str.next, order) # Send the order to whoever is listening.
end
```

This is in early stage development. Contact if you'd like to help.

# What's with the name ?

As [proven by science](https://arxiv.org/abs/1802.07068) :

![](https://y.yarn.co/684c9bf0-bd35-4063-93f2-d9dc882179fe_text.gif)
