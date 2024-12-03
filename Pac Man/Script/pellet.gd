extends Area2D
class_name Coin

signal coin_eaten(coin: Coin)  # Signal when  coin is collected

@onready var score_manager = $"../ScoreManager"  

@export var points: int = 10  # 10 points for each coin

# Function to detect when PacMan (or player) collects the coin
func _on_body_entered(body):
	if body.is_in_group("PacMan"):  # Check if the body that collided is PacMan
		emit_signal("coin_eaten", self)  # Notify that the coin was eaten
		score_manager.update_score(points)  # Update the score by the coin's point value
		queue_free()  # Remove the coin from the scene
