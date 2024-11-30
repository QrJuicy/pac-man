extends CharacterBody2D

## Adjust the movement speed of Pac-Man
@export var speed : float
## Status on whether Pac-Man is in powered-up state or not
@export var powerUp : bool = false
## Power Up timer
@export var powerUpTimer : Timer
## Sprite used for the Pac-Man
@export var sprite : AnimatedSprite2D
## Pac-Man detection area
@export var detector : Area2D

## Ghost group
@export var ghostGroup : String
## Power-up group
@export var powerUpGroup : String

@export var is_invincible : bool = false  # Add this to track invincibility state

# Declare the reference to the Poweruptimer child node (make sure the name matches exactly)
@onready var powerUpTimer : Timer = $Poweruptimer  # This connects to the Poweruptimer node in the scene

@export_group("ReadMe")
@export_multiline var Regarding_Sprite : String = "Please put the Pac-Man sprite as a children of the main parent, then assign it to the \"Sprite\" column.";
@export_multiline var Regarding_Ghost : String = "Put all ghosts in the same Group under Node > Group > \"+\" > Global = true, Then copy > paste the GroupName into the \"Ghost\" column. Make sure the ghosts are in the same physics layer as Pac-Man"

# Called when the scene is ready
func _ready():
	# Connect the signal from Poweruptimer to handle the end of the power-up effect
	powerUpTimer.connect("timeout", Callable(self, "_on_power_up_ended"))  # Using Callable(self, "method_name") instead of string

# Called every frame to update Pac-Man's movement
func _physics_process(delta):
	movement()
	if powerUp:
		power_Up()  # If power-up is active, handle the effect

# Called when something enters Pac-Man's detection area
func _on_detector_body_entered(body):
	if body.is_in_group(powerUpGroup):  # If Pac-Man collides with a power-up
		powerUp = true
		is_invincible = true  # Pac-Man becomes invincible when power-up is collected
		powerUpTimer.start()  # Start the power-up timer
		notify_ghosts_power_up(true)  # Notify all ghosts to switch to "scared" sprite

	if body.is_in_group(ghostGroup):  # Pac-Man collides with a ghost
		if is_invincible:  # If Pac-Man is invincible, destroy the ghost
			body.queue_free()
		else:  # If Pac-Man is not invincible, Pac-Man dies
			queue_free()

# Notify ghosts to change their sprite
func notify_ghosts_power_up(state: bool):
	for ghost in get_tree().get_nodes_in_group(ghostGroup):
		ghost.set_frightened() if state else ghost.reset_to_normal()

# Called to handle the movement of Pac-Man
func movement():
	# Get input
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	
	# X-axis movement
	if !direction_y:
		velocity.y = move_toward(velocity.y, 0, speed)
		velocity.x = direction_x * speed
		# sprite direction
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
		# sprite direction
		if direction_y > 0:
			sprite.flip_h = false
			sprite.rotation_degrees = 90
		elif direction_y < 0:
			sprite.flip_h = false
			sprite.rotation_degrees = 270
	move_and_slide()

# Function for when power-up is activated
func power_Up():
	# Handle what happens when Pac-Man is powered up (you can add special effects here)
	speed *= 1.5  # Increase Pac-Man's speed by 1.5 times
	sprite.modulate = Color(1, 0, 0)  # Change Pac-Man's color to red during the power-up

# Function to handle the end of the power-up
func _on_power_up_ended(): 
	powerUp = false  # Reset power-up state
	is_invincible = false  # Reset invincibility
	speed /= 1.5  # Reset Pac-Man's speed back to normal
	sprite.modulate = Color(1, 1, 1)  # Revert Pac-Man's color back to normal (white)
	notify_ghosts_power_up(false)  # Notify all ghosts to revert to normal sprite
	print("Power-up ended! Pac-Man is no longer invincible.")
