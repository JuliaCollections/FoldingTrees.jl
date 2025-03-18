using Documenter
using FoldingTrees

makedocs(;
    sitename="FoldingTrees.jl",
    modules=[FoldingTrees],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    authors="Tim Holy <tim.holy@gmail.com>",
)

deploydocs(;
    repo="github.com/JuliaCollections/FoldingTrees.jl",
)
