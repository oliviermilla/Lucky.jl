# Getting started

Lucky.jl

## Installation

Install Lucky.jl through the Julia package manager:

```Julia
] add Lucky
```

The package has very light dependencies other than its reactive async core: Rocket.jl.

Seamless integration with other packages (DataFrames, TimeSeries, Broker APIS, etc.), is done via extensions.

```Julia
# Natively import historical stock price from Yahoo into Lucky.
] add MarketData
```

## Concepts

A basic trading pipeline looks like this:

![](./assets/lucky.svg)

This is purely conceptual as brokers (such as Alpaca or Interactive Brokers for instance) most likely act as exchanges (where orders get matched) and blotters (where your positions are stored).

More interestingly, Lucky allows you to do these wiring in any way you'd like with as many steps as you'd like and different time frames all at once.

As a picture, consider that you'd like to have 3 strategies, with each being dedicated to adjusting the final decision to manage orders. 

1. Strategy one provides risk signals.
2. Next Strategy manages allocation targets. 
3. Final Strategy handles order execution.

Which means that such a design requires lots of wiring as strategy 2 needs to know your current position, while 3 will likey need to track the fills and positions.

Whatever it is you wish to build, the concepts remain where:

- **Operators** transform data.
- **Strategies** make decisions.
- **Exchanges** match orders.
- **Blotters** do the record keeping.

To do all this, Lucky leverages the Rocket library under the hood. 
Hence, familiarity with reactive programming concepts is nice (though not required).
You can refer to Rocket's documentation for more information [here](https://reactivebayes.github.io/Rocket.jl/stable/).

That's all we need to know for now.





