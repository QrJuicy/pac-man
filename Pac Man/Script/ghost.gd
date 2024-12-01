extends Area2D

class_name Ghost

enum GhostState {
	SCATTER, 
	CHASE,
	RUN_AWAY,
	EATEN
}

signal direction_change(current_direction: String)
signal run_away_timeout

var current_scatter_index = 0
var direction = null
var current_state: GhostState
var is_blinking = false

@export var speed = 120
@export var movement_targets: Resource
@export var tile_map: TileMap
@export var color: Color
@export var chasing_target: Node2D

@onready var navigation_agent_2d = $NavigationAgent2D
@onready var scatter_timer = $ScatterTimer
@onready var update_chasing_target_position_timer = $UpdateChasingTargetPositionTimer
@onready var eyes_sprite = $EyesSprite
@onready var body_sprite = $BodySprite 
@onready var run_away_timer = $RunAwayTimer

func _ready():
	navigation_agent_2d.path_desired_distance = 4.0
	navigation_agent_2d.target_desired_distance = 4.0
	navigation_agent_2d.target_reached.connect(on_position_reached)
	
	call_deferred("setup")
	

func _process(delta):
	if !run_away_timer.is_stopped() && run_away_timer.time_left < run_away_timer.wait_time / 2 && !is_blinking:
		start_blinking()
	if navigation_agent_2d.is_navigation_finished() and current_state == GhostState.CHASE:
		calculate_path_to_target(chasing_target.global_position)
	move_ghost(navigation_agent_2d.get_next_path_position(), delta)
	
	
func move_ghost(next_position: Vector2, delta: float):
	var current_ghost_position = global_position
	var new_velocity = (next_position - current_ghost_position).normalized() * speed * delta
	calculate_direction(new_velocity)
	position += new_velocity

func calculate_direction(new_velocity: Vector2):
	var current_direction
	
	if new_velocity.x > 1:
		current_direction = "right"
	elif new_velocity.x < -1:
		current_direction = "left"
	elif new_velocity.y > 1:
		current_direction = "down"
	elif new_velocity.y < -1:
		current_direction = "up"
		
	if current_direction != direction:
		direction = current_direction
		direction_change.emit(direction)

func setup():
	print(tile_map.get_navigation_map(0))
	navigation_agent_2d.set_navigation_map(tile_map.get_navigation_map(0))
	NavigationServer2D.agent_set_map(navigation_agent_2d.get_rid(), tile_map.get_navigation_map(0))
	scatter()
	
func scatter():
	scatter_timer.start()
	current_state = GhostState.SCATTER
	navigation_agent_2d.target_position = movement_targets.scatter_targets[current_scatter_index].position

func on_position_reached():
	if current_state == GhostState.SCATTER:
		scatter_position_reached()
	elif current_state == GhostState.CHASE:
		chase_position_reached()
	
func chase_position_reached():
	print("KILL PACMAN")

func scatter_position_reached():
	if current_scatter_index < 3:
		current_scatter_index += 1
	else:
		current_scatter_index = 0
		
	navigation_agent_2d.target_position = movement_targets.scatter_targets[current_scatter_index].position

func _on_scatter_timer_timeout():
	start_chasing_pacman()

func start_chasing_pacman():
	if chasing_target == null:
		print("NO CHASING TARGET. CHASING WILL NOT WORK!!")
		return
	current_state = GhostState.CHASE
	calculate_path_to_target(chasing_target.global_position)

func _on_update_chasing_target_position_time_timeout():
	calculate_path_to_target(chasing_target.global_position)

# A* Pathfinding Algorithm Implementation
func calculate_path_to_target(target_position: Vector2):
	if tile_map and navigation_agent_2d:
		navigation_agent_2d.target_position = target_position

func run_away_from_pacman():
	if run_away_timer.is_stopped():
		body_sprite.run_away()
		eyes_sprite.hide_eyes()
		run_away_timer.start()
	current_state = GhostState.RUN_AWAY
	update_chasing_target_position_timer.stop()
	scatter_timer.stop()
	
func start_blinking():
	body_sprite.start_blinking()

func _on_run_away_timer_timeout():
	run_away_timeout.emit()
	is_blinking = false
	eyes_sprite.show_eyes()
	body_sprite.move()
	start_chasing_pacman()
	
func get_eaten():
	body_sprite.hide()
	eyes_sprite.show_eyes()
	run_away_timer.stop()
	run_away_timeout.emit()
	current_state = GhostState.EATEN
	navigation_agent_2d.target_position = movement_targets.at_home_targets[0].position


func _on_body_entered(body: CharacterBody2D):
	var player = body as Player
	if current_state == GhostState.RUN_AWAY:
		get_eaten()
	elif current_state == GhostState.CHASE || current_state == GhostState.SCATTER:
		set_collision_mask_value(1, false)
		update_chasing_target_position_timer.stop()
		player.die()
		scatter_timer.wait_time = 600
		scatter()
