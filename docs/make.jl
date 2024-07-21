using Documenter
using Lucky

DocMeta.setdocmeta!(Lucky, :DocTestSetup, :(using Lucky); recursive=true)

makedocs(
    sitename="Lucky.jl",
    format=Documenter.HTML(),
    modules=[Lucky],
    doctest=true,
    clean=true,
    pages=[
        "Getting Started" => "getting-started.md",
        # "Strategies" => "strategies.md",
        # "Integrations" => "integrations/about.md",
        "Instruments" => [
            "About" => "instruments/instruments.md"
        ],
        # "Exchanges" => "exchanges/about.md",
        # "Blotters" => "blotters/about.md",
        "Units" => [
            "About" => "units/units.md",
            "Currencies" => "units/currencies.md"
        ],
        "Ohlc" => "ohlcs.md",
        "Glossary" => "glossary.md"
    ]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
