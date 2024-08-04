# Getting started

## Installation

Install Lucky.jl through the Julia package manager:

```Julia
] add Lucky
```

The package has very little dependencies other than Rocket.jl.

Integration with other packages (DataFrames, TimeSeries, Broker APIS, etc.) is done through extensions. You'll have to add the packages you need to trigger the integrations:

```Julia
# Natively import historical stock price from Yahoo into Lucky.
] add MarketData
```

## Concepts

Conceptually, a Lucky trading pipeline looks like this:

![](./assets/lucky.drawio.svg)

where

- **Operators** transform data.
- **Strategies** make decisions.
- **Exchanges** match orders.
- **Blotters** do the record keeping.

This is purely conceptual. For instance, brokers such as Alpaca or Interactive Brokers both act as exchanges and blotters. 

More interestingly, Lucky allows you to do these wiring in any way you'd like:
- Parallel steps (ex: different strategies running in parallel)
- Intermediary steps (ex: one strategy that takes as input the decisions of other strategies).
- Feeback loops (ex: one strategy that requires to know the state of a blotter).

In addition, 
- Messaging between blocks can be synchronous or asynchronous.
- Messaging is reactive, meaning that chains will be trigger only upon new incoming data.

Familiarity with reactive programming concepts helps but is not required.
You can refer to Rocket's documentation [here](https://reactivebayes.github.io/Rocket.jl/stable/). 

It provides 
- a crash course in reactive programming.
- documentation for key concepts upon which Lucky is built.
- documentation for dozens of operators that you can leverage in Lucky.

The rest of Lucky's documentation describes:
- The **Data Types** of objects transiting through these blocks.
- Common **Operators** that are provided with Lucky.
- The interfaces of key objects :
    - **Strategies**
    - **Exchanges**
    - **Blotters**

All conceps presented here derive from abstract types to allow easy integration of more specialized types.

Finally, the "Integrations" section will present the currently implemented integrations.

Enjoy.

# First example

See the `src/examples` folder for a first commented example and its jupyter version.





