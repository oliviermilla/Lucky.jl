# [rolling](@id rolling)

```@docs
    rolling
```

```@example        
    using Lucky
    using Rocket
    source = from(1:5)
    subscribe!(source |> rolling(3), logger())
    nothing #hide
```