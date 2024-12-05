extends Resource

@export var scatter_targets: Array[NodePath] 
@export var at_home_targets: Array[NodePath]

func process_targets(parent: Node):
	for path in scatter_targets:
		var node = parent.get_node(path) as Node2D
		if node:
			print(node.name)
