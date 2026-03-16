using LogicalOperators
using Documenter

makedocs(
    build = joinpath(@__DIR__, "local" in ARGS ? "build_local" : "build"),
    modules = [LogicalOperators],
    clean = false,
    format = Documenter.HTML(
        prettyurls = !("local" in ARGS),
        assets = ["assets/custom.css"],
    ),
    sitename = "LogicalOperators.jl 🧩",
    authors = "WooKyoung Noh",
    pages = Any[
        "Home" => "index.md",
    ],
)
