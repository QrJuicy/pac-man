extends Area2D
class_name Coin
signal coin_eaten(coin:Coin)
@export var should_allow_eating_ghosts = false
func _on_body_entered(body):
	if body is Player:
		coin.eaten.emit(self)
		queue_free()
		if should_allow_eating_ghosts:
			pass
