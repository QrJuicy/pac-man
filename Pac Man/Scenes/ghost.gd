extends Area2D

class_name Ghost

signal direction_change(current_direction: String)

var current_scatter_index = 0
var direction = null
var collide = false 

@export var speed = 120
@export var movement_targets: Resource
@export var tile_map: TileMap
@export var color: Color

@onready var navigation_agent_2d = $NavigationAgent2D

func _ready():
	navigation_agent_2d.path_desired_distance = 4.0
	navigation_agent_2d.target_desired_distance = 4.0
	navigation_agent_2d.target_reached.connect(on_position_reached)
	
	call_deferred("setup")
	

func _process(delta):
	move_ghost(navigation_agent_2d.get_next_path_position(), delta)
	
	
func move_ghost(next_position: Vector2, delta: float):
	var current_ghost_position = global_position
	var new_velocity = (next_position - current_ghost_position).normalized() * speed * delta;
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
	navigation_agent_2d.target_position = movement_targets.scatter_targets[current_scatter_index].position

func on_position_reached():
	if current_scatter_index < 3:
		current_scatter_index += 1
	else:
		current_scatter_index = 0
		
	navigation_agent_2d.target_position = movement_targets.scatter_targets[current_scatter_index].position
