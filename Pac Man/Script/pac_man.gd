extends CharacterBody2D

class_name Player

signal player_died

#variables
var next_movement_direction = Vector2.ZERO
var movement_direction = Vector2.ZERO

##Adjust the movement speed of Pac-Man
@export var speed : float
##Status on whether Pac-Man is in powered up state or no
@export var powerUp : bool = false
##Power Up timer
@export var powerUpTimer : Timer
##Sprite used for the Pac-Man
@export var sprite : AnimatedSprite2D
##Pac-Man detection area
@export var detector : Area2D

##Ghost group
@export var ghostGroup : String
##Powerup group
@export var powerUpGroup : String

@export_group("ReadMe")
@export_multiline var Regarding_Sprite : String = "Please put the Pac-Man sprite as a children of the main parent, then assign it to the \"Sprite\" column.";
@export_multiline var Regarding_Ghost : String = "Put all ghosts in the same Group under Node > Group > \"+\" > Global = true, Then copy > paste the GroupName into the \"Ghost\" column. Make sure the ghosts are in the same physics layer as Pac-Man"

@export var start_position: Node2D

var max_lives = 3
var current_lives = max_lives
@onready var lives_ui = $"../LivesUI"
@onready var animation_player = $AnimationPlayer

func _ready():
	reset_player()

func reset_player():
	animation_player.play("default")
	position = start_position.position
	set_physics_process(true)
	next_movement_direction = Vector2.ZERO
	movement_direction = Vector2.ZERO

func _physics_process(_delta):
	movement()
	if powerUp:
		power_Up()
	
	#Debugger
	#print(direction_x)
	#print(direction_y)
func _on_detector_body_entered(body):
	if body.is_in_group(powerUpGroup):#PowerUp activator
		powerUp = true
		powerUpTimer.start() 
	
	if body.is_in_group(ghostGroup):
		var ghost = body as Ghost
		if powerUp:#Destroy ghost if powerUp on
			##body.queue_free() <--- previous code, can be deleted if the current one works
			ghost.get_eaten()
		if !powerUp:#Destroyed by ghost if powerUp off
			##queue_free() <--- previous code, can be deleted if the current one works
			die()

func movement():
	#Get input
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	
	#X-axis movement by inverting the condition
	if !direction_y:
		velocity.y = move_toward(velocity.y, 0, speed)
		velocity.x = direction_x * speed
			#sprite direction
		if direction_x > 0:
			sprite.rotation_degrees = 0
			sprite.flip_h = false
		elif direction_x < 0:
			sprite.rotation_degrees = 0
			sprite.flip_h = true
			
	#Y-axis movement by inverting the condition
	elif !direction_x:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = direction_y * speed
			#sprite direction
		if direction_y > 0:
			sprite.flip_h = false
			sprite.rotation_degrees = 90
		elif direction_y < 0:
			sprite.flip_h = false
			sprite.rotation_degrees = 270
	move_and_slide()

func power_Up():
	powerUp = true; 

func _on_power_up_timer_timeout(): 
	powerUp = false

func die():
	current_lives -= 1  # Decrease lives 
	lives_ui.update_lives()  # Update the lives 
	
	if current_lives > 0:
		reset_position()
	else:
		print("Game Over!")
		get_tree().change_scene("res://Scenes/game_over_screen.tscn")  # Example Game Over scene path

# Reset Pac-Man's position (respawn logic)
func reset_position():
	position = Vector2(0, 200)  #reset position
	powerUp = false  


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		player_died.emit()
		reset_player()
