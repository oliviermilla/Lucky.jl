using Documenter
using Lucky

DocMeta.setdocmeta!(Lucky, :DocTestSetup, :(using Lucky, Rocket); recursive=true)

makedocs(
    sitename="Lucky.jl",
    format=Documenter.HTML(),
    modules=[Lucky],
    doctest=true,
    clean=true,
    pages=[
        "Getting Started" => "getting-started.md",
        "Data Types" => [
            "Data Types" => "datatypes.md",
            "Fills" => "fills.md",
            "Indicators" => "indicators.md",
            "Instruments" => [
                "Instruments" => "instruments/instruments.md",
                "Bonds" => "instruments/bonds.md",
                "Cash" => "instruments/cash.md",
                "Futures" => "instruments/futures.md",
                "Stocks" => "instruments/stocks.md"
            ],
            "Ohlc" => "ohlcs.md",
            "Orders" => "orders.md",
            "Positions" => "positions.md",
            "Quotes" => "quotes.md",
            "Trades" => "trades.md",            
        ],
        "Operators" => [
            "Operators" => "operators.md",
            "rolling" => "operators/rolling.md"
        ],
        "Units" => [
            "Units" => "units/units.md",
            "Currencies" => "units/currencies.md"
        ],
        "Integrations" => [
            "Integrations" => "integrations.md"
            #"IBKR" => "integrations/ibkr.md"
        ],
        "Glossary" => "glossary.md"
    ]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/oliviermilla/Lucky.jl.git"
)
