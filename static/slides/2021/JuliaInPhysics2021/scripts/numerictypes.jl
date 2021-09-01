using InteractiveUtils

root = Number
graph = IdDict()
nodes = Any[root]
while !isempty(nodes)
    node = pop!(nodes)
    for T in subtypes(node)
        graph[T] = node
        push!(nodes, T)
    end
end

println("digraph {")
println("rankdir=\"BT\"")
println("\"$(root)\" [shape=box, style=rounded]")
for key in keys(graph)
    style = isabstracttype(key) ? "rounded" : "solid"
    println("\"$(key)\" [shape=box, style=$style]")
    println("\"$(key)\" -> \"$(graph[key])\"")
end
println("}")