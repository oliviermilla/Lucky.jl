using Documenter
using Lucky

makedocs(
    sitename="Lucky.jl",
    format=Documenter.HTML(),
    modules=[Lucky],
    clean=true,
    pages=[
        "Getting Started" => "getting-started.md",
        # "Strategies" => "strategies.md",
        # "Integrations" => "integrations/about.md",
        # "Instruments" => "instruments/about.md",
        # "Exchanges" => "exchanges/about.md",
        # "Blotters" => "blotters/about.md",
        "Units" => ["units/about.md",
            "Currencies" => "units/currencies.md"
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
