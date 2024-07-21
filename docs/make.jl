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
            "About" => "datatypes.md",
            "Fills" => "fills.md",
            "Indicators" => "indicators.md",
            "Instruments" => [
                "About" => "instruments/instruments.md",
                "Cash" => "instruments/cash.md",
                "Stocks" => "instruments/stocks.md"
            ],
            "Ohlc" => "ohlcs.md",
            "Orders" => "orders.md",
            "Positions" => "positions.md",
            "Quotes" => "quotes.md",
            "Trades" => "trades.md",            
        ],
        "Operators" => [
            "About" => "operators.md",
            "rolling" => "operators/rolling.md"
        ],
        "Units" => [
            "About" => "units/units.md",
            "Currencies" => "units/currencies.md"
        ],
        "Integrations" => [
            "About" => "integrations.md",
            "IBKR" => "integrations/ibkr.md"
        ],
        "Glossary" => "glossary.md"
    ]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
