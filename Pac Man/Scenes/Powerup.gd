extends Area2D

# Signal function, called when a body enters the CollisionShape2D
func _on_Powerup_body_entered(body):
	if body.name == "Player":  # Replace "Player" with the name of your Pacman node
		apply_powerup_effect()
		queue_free()  # Removes the power-up from the scene after it's collected

# Function to define what happens when the power-up is collected
func apply_powerup_effect():
	print("Powerup collected!")
	# Add your custom logic here (e.g., make Pacman invincible, increase speed, etc.)
