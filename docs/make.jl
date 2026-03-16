using LogicalOperators
using .LogicalOperators: AND, OR, XOR, NOT
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
        "macros" => "macros.md",
        "operators" => "operators.md",
    ],
)
