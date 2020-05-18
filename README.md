# FoldingTrees

[![Build Status](https://travis-ci.com/JuliaCollections/FoldingTrees.jl.svg?branch=master)](https://travis-ci.com/JuliaCollections/FoldingTrees.jl)
[![Codecov](https://codecov.io/gh/JuliaCollections/FoldingTrees.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaCollections/FoldingTrees.jl)

FoldingTrees implements a dynamic [tree structure](https://en.wikipedia.org/wiki/Tree_%28data_structure%29) in which some nodes may be "folded," i.e., marked to avoid descent among that node's children.

For example, after saying `using FoldingTrees`, a "table of contents" like

    I. Introduction
      A. Some background
        1. Stuff you should have learned in high school
        2. Stuff even Einstein didn't know
      B. Defining the problem
    II. How to solve it

could be created like this:

```julia
root = Node("")
chap1 = Node("Introduction", root)
chap1A = Node("Some background", chap1)
chap1A1 = Node("Stuff you should have learned in high school", chap1A)
chap1A2 = Node("Stuff even Einstein didn't know", chap1A)
chap1B = Node("Defining the problem", chap1)
chap2 = Node("How to solve it", root)
```

You don't have to create them in this exact order, the only constraint is that you create the parents before the children.
In general you create a node as `Node(data, parent)`, where `data` can be any type.
The root node is the only one that you create without a parent, i.e., `root = Node(data)`, and the type of data used to create `root` is enforced for all leaves of the tree.
You can specify the type with `root = Node{T}(data)` if necessary.

Using the [AbstractTrees](https://github.com/JuliaCollections/AbstractTrees.jl) package,
the tree above displays as

```julia
julia> print_tree(root)
  
├─   Introduction
│  ├─   Some background
│  │  ├─   Stuff you should have learned in high school
│  │  └─   Stuff even Einstein didn't know
│  └─   Defining the problem
└─   How to solve it
```

Now let's fold the section named "Some background":

```julia
julia> fold!(chap1A)
true

julia> print_tree(root)
  
├─   Introduction
│  ├─ + Some background
│  └─   Defining the problem
└─   How to solve it
```

You can use `unfold!` to reverse the folding and `toggle!` to switch folding.

There are a few utilities that you can learn about by reading their docstrings:

- `isroot`: determine whether a node is the root node
- `count_open_leaves`: count the number of nodes in the tree above the first fold on all branches
- `next`, `prev`: efficient ordered visitation of open nodes (depth-first)
- `nodes`: access nodes, rather than their data, during iteration (example: `foreach(unfold!, nodes(root)))`
