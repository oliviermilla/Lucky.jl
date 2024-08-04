# [Data Types](@id datatypes)

You can use Lucky with plain julia standard types (Float64, etc.).
Nevertheless, you will realize that any block receiving data will need more annotation to leverage multiple dispatch.

Let's see that in practice.

```@example
    using Lucky
    using Rocket

    struct MyStrategy <: AbstractStrategy
    end

    function Rocket.on_next!(strat::MyStrategy, data::Float64)
        # Do whatever you want and return Orders.
        @info "Data Received: $(data)"
    end

    function Rocket.on_complete!(strat::MyStrategy)
        # Do nothing.
    end

    strat = MyStrategy()
    Rocket.subscribe!(Rocket.from([1.1, 2.2, 3.3]), strat)
    Rocket.subscribe!(Rocket.from([0.9, 1.9, 2.9]), strat)
    nothing # hide
```
This basic code feeds `strat` with two feeds of `Float64`. Both feeds will trigger the `on_next!` function, making it impossible to differentiate the two feeds if they represent different things.

The solution here is to annotate your information. For instance, if the first feed of the above example represents weights and the second represents heights, here is the proper way to write it:

```@example
    using Lucky
    using Rocket

    struct Weight
        value::Float64
    end
    struct Height
        value::Float64
    end

    struct MyStrategy <: AbstractStrategy
    end

    function Rocket.on_next!(strat::MyStrategy, data::Weight)
        # Do whatever you want and return Orders.
        @info "Weight Received: $(data)"
    end

    function Rocket.on_next!(strat::MyStrategy, data::Height)
        # Do whatever you want and return Orders.
        @info "Height Received: $(data)"
    end

    function Rocket.on_complete!(strat::MyStrategy)
        # Do nothing.
    end

    strat = MyStrategy()
    Rocket.subscribe!(Rocket.from([1.1, 2.2, 3.3]) |> map(Weight, x -> Weight(x)), strat)
    Rocket.subscribe!(Rocket.from([0.9, 1.9, 2.9]) |> map(Height, x -> Height(x)), strat)
    nothing # hide
```
Since we have different types, two different methods will get triggered depending on the type of information.

!!! info
    You could also have written a single `Rocket.on_next!(strat::MyStrategy, data::Any)` method and differentiate the type in the method. Though sometimes useful, the presented method is common.

Lucky makes a lot of effort to preserve types along all steps and offers convenient methods to track types. For instance, let's say we want to use the `sma` operator on the first feed from the above examples:

<!-- @example
    using Lucky
    using Rocket

    struct Weight{F} <: ValueIndicator{F}
        value::F
    end

    # Weight feed from the above example with a Simple Moving Average
    Rocket.subscribe!(Rocket.from([1.1, 2.2, 3.3]) |> map(Weight, x -> Weight(x)) |> sma(2), logger())
    nothing # hide
 -->

## Common Interfaces

Many objects share methods that allow access to reference types or data.
Current methods are:

```@docs
    Lucky.currency
    Lucky.timestamp
```

In addition, all Lucky objects have type methods that allow you to know beforehand the types that you should expect. These methods share a naming convention: they all finish with `Type`.

```@example
    using Lucky

    struct Weight
        value::Float64
    end

    smaType = IndicatorType(SMAIndicator, 2, Weight)
```