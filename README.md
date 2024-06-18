# Lucky

[![Build Status](https://github.com/oliviermilla/Lucky.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/oliviermilla/Lucky.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![codecov](https://codecov.io/gh/oliviermilla/Lucky.jl/graph/badge.svg?token=7SAX9EXGHM)](https://codecov.io/gh/oliviermilla/Lucky.jl)

Lucky is a trading framework for Julia designed to 

- (very) rapidly test and deploy trading statregies with next to zero code change between the two.
- run very fast by leveraging Julia's multiple dispatch paradigm and [Rocket.jl](https://github.com/ReactiveBayes/Rocket.jl) as its **asynchronous** and **reactive** core.
- being super simple to start with and modular to tailor and extend to different needs.
- accomodate different kind of strategies, data or experiements (market making, random process simulation, etc.) leveraging Julia's powerful math libraries ecosystem.

## Example code

A documented and working example is available in the examples folder [here](https://github.com/oliviermilla/Lucky.jl/blob/main/examples/goldencross.jl).

## Integrations

Lucky.jl is designed to be extendable to any API data source (including brokers) and/or data types.

At the day of writing, the libray integrates the following integrations:

| Library                                                      | Type                                                              | Comments                                       |
|--------------------------------------------------------------|-------------------------------------------------------------------|------------------------------------------------|
| [MarketData.jl](https://github.com/JuliaQuant/MarketData.jl) | Historical financial time series from Yahoo, FRED, ONS.           | - Yahoo :heavy_check_mark:| 
| [TimeSeries.jl](https://github.com/JuliaStats/TimeSeries.jl) | Lightweight framework for working with time series data in Julia. | :heavy_check_mark:                                       |
| [InteractiveBrokers.jl](https://github.com/oliviermilla/InteractiveBrokers.jl)                   | Pure Julia API to Interactive Brokers                             | :heavy_check_mark:  Partial                        |
| Random                                                       | Standard Julia Random Library                                     | :heavy_check_mark:                                       |

## Data Types
The library provides interface to handle Open High Low Close data (if that's what you're into).

**The library is in development. Contact if you'd like to help.**

# What's with the name ?

As [proven by science](https://arxiv.org/abs/1802.07068) :

![](https://y.yarn.co/684c9bf0-bd35-4063-93f2-d9dc882179fe_text.gif)

Trade safely!
