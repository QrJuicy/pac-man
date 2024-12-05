extends Node2D

class_name MovementTarget

@export var scatter_targets: Array[Marker2D] 
@export var at_home_targets: Array[Marker2D]

func get_scarlet_position(_parent: Node) -> Vector2:
	# Check if the first scatter target exists and return its global position
	if scatter_targets.size() > 0 and scatter_targets[0]:
		return scatter_targets[0].global_position
	return Vector2.ZERO


