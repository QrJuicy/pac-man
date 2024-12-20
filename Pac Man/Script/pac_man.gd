extends CharacterBody2D

class_name Player

signal player_died(life: int)

#variables
var next_movement_direction = Vector2.ZERO
var movement_direction = Vector2.ZERO
var shape_query = PhysicsShapeQueryParameters2D.new()
var is_powered = false

#export variables
@export var speed = 300
@export var start_position: Node2D
@export var pacman_death_sound_player: AudioStreamPlayer2D
@export var pellets_manager: PelletsManager
@export var powerup_timer : Timer
@export var lifes: int = 2
@export var ui: UI

#onready variables
@onready var direction_pointer = $DirectionPointer
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $Detector/CollisionShape2D
@onready var scarlet = $"../Ghosts/Scarlet"

func _ready():
	shape_query.shape = collision_shape_2d.shape
	shape_query.collision_mask = 2
	ui.set_lifes(lifes)
	reset_player()

func reset_player():
	animation_player.play("default")
	position = start_position.position
	set_physics_process(true)
	next_movement_direction = Vector2.ZERO
	movement_direction = Vector2.ZERO
	
func _physics_process(delta):
	get_input()
	
	if movement_direction == Vector2.ZERO:
		movement_direction = next_movement_direction
	if can_move_in_direction(next_movement_direction, delta):
		movement_direction = next_movement_direction
	
	velocity = movement_direction * speed
	move_and_slide()
	
	if scarlet.current_state == scarlet.GhostState.RUN_AWAY:
		print("scarlet run away")
	
func get_input():
	if Input.is_action_pressed("left"):
		next_movement_direction = Vector2.LEFT
		rotation_degrees = 0
	elif  Input.is_action_pressed("right"):
		next_movement_direction = Vector2.RIGHT
		rotation_degrees = 180
	elif Input.is_action_pressed("down"):
		next_movement_direction = Vector2.DOWN
		rotation_degrees = 270
	elif Input.is_action_pressed("up"):
		next_movement_direction = Vector2.UP
		rotation_degrees = 90

func can_move_in_direction(dir: Vector2, delta: float) -> bool:
	shape_query.transform = global_transform.translated(dir * speed * delta * 2)
	var result = get_world_2d().direct_space_state.intersect_shape(shape_query)
	return result.size() == 0	

func die():
	pellets_manager.power_pellet_sound_player.stop()
	if !pacman_death_sound_player.playing:
		pacman_death_sound_player.play()
	animation_player.play("death")
	set_physics_process(false)

func _on_animation_player_animation_finished(anim_name):
		
	if anim_name == "death":
		lifes -= 1
		ui.set_lifes(lifes)
		player_died.emit(lifes)
		if lifes != 0:
			
			reset_player()
		else:
			position = start_position.position
			set_collision_layer_value(1, false)
	
func powerup():#<--- powerup activator
	powerup_timer.start()
	is_powered = true
	print(powerup_timer.wait_time)
	
func _on_powerup_timer_timeout():#<--- powerup deactivator
	print("power off")
	is_powered = false
	print(powerup_timer.wait_time)

