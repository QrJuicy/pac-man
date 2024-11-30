extends CharacterBody2D

# Adjust the movement speed of Pac-Man
@export var speed : float
# Status on whether Pac-Man is in powered-up state or not
@export var powerUp : bool = false
# Power-Up timer
@export var powerUpTimer : Timer
# Sprite used for Pac-Man
@export var sprite : AnimatedSprite2D
# Pac-Man detection area
@export var detector : Area2D

# Ghost group
@export var ghostGroup : String
# Power-up group
@export var powerUpGroup : String

@export_group("ReadMe")
@export_multiline var Regarding_Sprite : String = "Please put the Pac-Man sprite as a children of the main parent, then assign it to the \"Sprite\" column.";
@export_multiline var Regarding_Ghost : String = "Put all ghosts in the same Group under Node > Group > \"+\" > Global = true, Then copy > paste the GroupName into the \"Ghost\" column. Make sure the ghosts are in the same physics layer as Pac-Man"

# Physics process for Pac-Man movement and power-up state
func _physics_process(delta):
	movement()
	if powerUp:
		power_Up()

# Detect collision with power-up or ghosts
func _on_detector_body_entered(body):
	if body.is_in_group(powerUpGroup): # PowerUp activator
		powerUp = true
		powerUpTimer.start()  # Start the power-up timer

	if body.is_in_group(ghostGroup):
		if powerUp:  # Destroy ghost if power-up is active
			body.queue_free()  # Remove ghost from the scene
		if !powerUp:  # Pac-Man dies if power-up is not active
			die()

# Movement handling
func movement():
	# Get input from the player (WASD or arrow keys)
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	
	# X-axis movement
	if !direction_y:
		velocity.y = move_toward(velocity.y, 0, speed)
		velocity.x = direction_x * speed
		# Sprite direction
		if direction_x > 0:
			sprite.rotation_degrees = 0
			sprite.flip_h = false
		elif direction_x < 0:
			sprite.rotation_degrees = 0
			sprite.flip_h = true
	
	# Y-axis movement
	elif !direction_x:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = direction_y * speed
		# Sprite direction
		if direction_y > 0:
			sprite.flip_h = false
			sprite.rotation_degrees = 90
		elif direction_y < 0:
			sprite.flip_h = false
			sprite.rotation_degrees = 270
	
	move_and_slide()  # Move Pac-Man with sliding

# Power-Up state: Enable ghost eating and temporary invincibility
func power_Up():
	sprite.modulate = Color(0, 0, 1)  # Example: Change sprite color to blue (frightened state)


# Power-Up timer timeout: Deactivate after the timer expires
func _on_power_up_timer_timeout():
	powerUp = false  # Reset power-up status
	sprite.modulate = Color(1, 1, 1)  # Reset sprite color to normal (Optional)

# Pac-Man DIES
func die():
	print("DIED")
	queue_free()  # Remove Pac-Man from the scene
