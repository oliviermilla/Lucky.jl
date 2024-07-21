# [Quotes](@id quotes)

A Quote is a value offered or asked at which an Instrument can be traded.

The most common use case is a PriceQuote but not all instruments quote on prices.

Another Quote type is OhlcQuote which describes historical prices as if they were historical ranged quote streams.

```@docs
    Lucky.AbstractQuote
    Lucky.Quote
    Lucky.PriceQuote
    Lucky.OhlcQuote
```