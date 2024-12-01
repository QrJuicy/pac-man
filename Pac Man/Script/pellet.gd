extends Area2D
class_name Coin
signal pellet_eaten(should_allow_eating_ghosts: bool)

@export var should_allow_eating_ghosts = false

func _on_body_entered(body):
	if body is Player:
		pellet.eaten.emit(should_allow_eating_ghosts)
		queue_free()
		if should_allow_eating_ghosts:
			pass