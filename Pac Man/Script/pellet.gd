extends Area2D
class_name Coin
signal pellet_eaten(should_allow_eating_ghosts: bool)

@export var should_allow_eating_ghosts = false
@onready var score_system = $"../../Score"


func _on_body_entered(body):
	if body is Player:
		pellet_eaten.emit(should_allow_eating_ghosts)
		score_system.update_score(1)
		queue_free()
		if should_allow_eating_ghosts:
			pass
