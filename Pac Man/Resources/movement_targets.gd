extends Resource

@export var scatter_targets: Array[NodePath] 
@export var at_home_targets: Array[NodePath]

func process_targets(parent: Node):
	for path in scatter_targets:
		var node = parent.get_node(path) as Node2D
		if node:
			print(node.name)
			
# Function to get Scarlet's position
func get_scarlet_position(parent: Node) -> Vector2:
	# Assuming Scarlet's target is the first in scatter_targets
	if scatter_targets.size() > 0:
		var node = parent.get_node_or_null(scatter_targets[0])  # Resolve path using parent
		if node:
			return node.global_position
	return Vector2.ZERO


