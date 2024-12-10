class_name GridGraph


class GridGraphNode:
    var positon: Vector2i
    var neighbors: Dictionary = {}
    var color: int = 0


var size: Vector2i
var nodes: Array[Array] = []


func _init(grid_width: int, grid_height: int) -> void:
    size = Vector2i(grid_width, grid_height)
    for y in grid_height:
        nodes.append([])
        for x in grid_width:
            var node: GridGraphNode = GridGraphNode.new()
            node.positon = Vector2i(x, y)
            nodes[y].append(node)


func find_hamiltonian() -> void:
    pass


func color_connected(start_node: GridGraphNode, color: int) -> void:
    var current_node: GridGraphNode = start_node
    var next: Array[GridGraphNode] = start_node.neighbors.values().duplicate()
    while not next.is_empty():
        current_node.color = color
        next.append_array(current_node.neighbors.values())
        current_node = next.pop_back()


func node_at(x: int, y: int) -> GridGraphNode:
    return nodes[y][x]


func node_at_vec(p: Vector2i) -> GridGraphNode:
    return nodes[p.y][p.x]


func get_kernel(kernel: Rect2i) -> Array[Array]:
    var kernel_nodes: Array[Array] = []
    for dy in kernel.size.y:
        kernel_nodes.append([])
        for dx in kernel.size.x:
            var dp: Vector2i = Vector2i(dx, dy)
            kernel_nodes[dy].append(node_at_vec(kernel.position + dp))
    return kernel_nodes
