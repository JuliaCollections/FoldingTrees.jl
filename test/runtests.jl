using FoldingTrees
using Test

function collectexposed(root)
    function collect!(lines, depths, node, depth)
        push!(lines, node.data)
        push!(depths, depth)
        if !node.foldchildren
            for child in node.children
                collect!(lines, depths, child, depth+1)
            end
        end
        return lines, depths
    end

    lines, depths = eltype(root)[], Int[]
    return collect!(lines, depths, root, 0)
end

function getroot(node)
    while !isroot(node)
        node = node.parent
    end
    return node
end

function checknext(node, depth, lines, depths)
    for i = 2:count_open_leaves(getroot(node))
        node, depth = next(node, depth)
        @test node.data == lines[i]
        @test depth == depths[i]
    end
end

function checkprev(node, depth, lines, depths)
    for i = count_open_leaves(getroot(node)):-1:2
        @test node.data == lines[i]
        @test depth == depths[i]
        node, depth = prev(node, depth)
    end
end

@testset "FoldingTrees.jl" begin
    root = Node("")
    child1 = Node("1", root)
    child1a = Node("1a", child1)
    child1a1 = Node("1a1", child1a)
    child1b = Node("1b", child1)
    child1b1 = Node("1b1", child1b)
    child1b2 = Node("1b2", child1b)
    child2 = Node("2", root)
    child3 = Node("3", root)
    child3a = Node("3a", child3)
    child3b = Node("3b", child3)
    child3b1 = Node("3b1", child3b)
    child3c = Node("3c", child3)

    for folded in (false, true)
        # For child2, folding has no impact, so we can run the same tests
        child2.foldchildren = folded

        @test count_open_leaves(root) == 13
        @test count_open_leaves(child1) == 6
        @test count_open_leaves(child2) == 1
        @test count_open_leaves(child3) == 5

        lines, depths = collectexposed(root)
        @test collect(root) == lines
        @test collect(child1) == lines[2:7]
        @test collect(child2) == lines[8:8]
        @test collect(child3) == lines[9:end]
        checknext(root, 0, lines, depths)
        checkprev(child3c, 2, lines, depths)
    end

    child1b.foldchildren = true
    @test count_open_leaves(root) == 11
    @test count_open_leaves(child1) == 4
    @test count_open_leaves(child2) == 1
    @test count_open_leaves(child3) == 5
    lines, depths = collectexposed(root)
    @test collect(root) == lines
    @test collect(child1) == lines[2:5]
    @test collect(child2) == lines[6:6]
    @test collect(child3) == lines[7:end]
    checknext(root, 0, lines, depths)
    checkprev(child3c, 2, lines, depths)

    child1b.foldchildren = false
    child1a.foldchildren = true
    @test count_open_leaves(root) == 12
    @test count_open_leaves(child1) == 5
    @test count_open_leaves(child2) == 1
    @test count_open_leaves(child3) == 5
    lines, depths = collectexposed(root)
    @test collect(root) == lines
    @test collect(child1) == lines[2:6]
    @test collect(child2) == lines[7:7]
    @test collect(child3) == lines[8:end]
    checknext(root, 0, lines, depths)
    checkprev(child3c, 2, lines, depths)

    child3b.foldchildren = true
    @test count_open_leaves(root) == 11
    @test count_open_leaves(child1) == 5
    @test count_open_leaves(child2) == 1
    @test count_open_leaves(child3) == 4
    lines, depths = collectexposed(root)
    @test collect(root) == lines
    @test collect(child1) == lines[2:6]
    @test collect(child2) == lines[7:7]
    @test collect(child3) == lines[8:end]
    checknext(root, 0, lines, depths)
    checkprev(child3c, 2, lines, depths)
end
