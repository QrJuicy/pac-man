extends Area2D

class_name Ghost

# Enums for ghost type and state
enum GhostType { 
	SCARLET, 
	BLUSH, 
	AZURE, 
	AMBER 
}

enum GhostState {
	SCATTER, 
	CHASE,
	RUN_AWAY,
	EATEN,
	STARTING_AT_HOME
}

# Signals for specific events
signal direction_change(direction: String)
signal run_away_timeout

# Variables for movement and state
var current_scatter_index 
var current_at_home_index
var direction = null
var current_state: GhostState
var is_blinking = false

# Exported variables for customization
@export var ghost_type: String              # Ghost type (scarlet, blush, azure, amber)
@export var scatter_wait_time = 8           # Scatter timer wait time
@export var eaten_speed = 240               # Speed when eaten
@export var speed = 120                     # Regular movement speed
@export var movement_targets: Node2D        # Reference to movement targets
@export var tile_map: MazeTileMap           # Reference to the maze's tilemap
@export var color: Color                    # Ghost's color
@export var chasing_target: Node2D          # Target node (Pac-Man)
@export var points_manager: PointsManager   # Reference to points system
@export var is_starting_at_home = false     # Whether the ghost starts in "home"
@export var starting_position: Node2D       # Starting Point for Ghost and Player
@export var cell_size: Vector2 = Vector2(32, 32)  # Default tile size

# Node references using @onready
@onready var at_home_timer = $AtHomeTimer
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var scatter_timer = $ScatterTimer
@onready var update_chasing_target_position_timer = $UpdateChasingTargetPositionTimer
@onready var eyes_sprite = $EyesSprite as EyesSprite
@onready var body_sprite = $BodySprite as BodySprite
@onready var run_away_timer = $RunAwayTimer
@onready var points_label = $PointsLabel
@onready var animation_player = $AnimationPlayer

func _ready():
	# Setup navigation and initial state
	scatter_timer.wait_time = scatter_wait_time
	at_home_timer.timeout.connect(scatter)
	navigation_agent_2d.path_desired_distance = 4.0
	navigation_agent_2d.target_desired_distance = 4.0
	navigation_agent_2d.target_reached.connect(on_position_reached)
	current_scatter_index = 0
	current_at_home_index = 0
	
	call_deferred("setup")

func _process(delta):
	# Handle blinking during "run away"
	if !run_away_timer.is_stopped() and run_away_timer.time_left < run_away_timer.wait_time / 2 and !is_blinking:
		start_blinking()

	# Continue pathfinding for CHASE state
	if navigation_agent_2d.is_navigation_finished() and current_state == GhostState.CHASE:
		calculate_path_to_target(chasing_target.position)
	
	move_ghost(navigation_agent_2d.get_next_path_position(), delta)

func move_ghost(next_position: Vector2, delta: float):
	# Move ghost towards the next position
	var current_ghost_position = global_position
	var current_speed = eaten_speed if current_state == GhostState.EATEN else speed
	var new_velocity = (next_position - current_ghost_position).normalized() * current_speed * delta
	
	calculate_direction(new_velocity)
	
	position += new_velocity
	
func calculate_direction(new_velocity: Vector2):
	# Determine the current direction based on velocity
	var current_direction
	if new_velocity.x > 1:
		current_direction = "right"
	elif new_velocity.x < -1:
		current_direction = "left"
	elif new_velocity.y > 1:
		current_direction = "down"
	elif new_velocity.y < -1:
		current_direction = "up"

	# Emit signal only if the direction is valid
	if current_direction != direction:	
		direction = current_direction
		direction_change.emit(direction)

func setup():
	set_collision_mask_value(1, true)
	position = starting_position.position
	# Initialize navigation map and starting state
	navigation_agent_2d.set_navigation_map(tile_map.get_navigation_map(0))
	NavigationServer2D.agent_set_map(navigation_agent_2d.get_rid(), tile_map.get_navigation_map(0))
	eyes_sprite.show_eyes()
	body_sprite.move()
	if is_starting_at_home:
		start_at_home()
	else:
		scatter()

func start_at_home():
	# Handle the starting "home" state
	current_state = GhostState.STARTING_AT_HOME
	at_home_timer.start()
	navigation_agent_2d.target_position = movement_targets.at_home_targets[current_at_home_index].position
	
func scatter():
	# Start scatter mode
	scatter_timer.start()
	current_state = GhostState.SCATTER
	navigation_agent_2d.target_position = movement_targets.scatter_targets[current_scatter_index].position

func on_position_reached():
	# Handle actions upon reaching a target position
	if current_state == GhostState.SCATTER:
		scatter_position_reached()
	elif current_state == GhostState.CHASE:
		chase_position_reached()
	elif current_state == GhostState.RUN_AWAY:
		run_away_from_pacman()
	elif current_state == GhostState.EATEN:
		start_chasing_pacman_after_being_eaten()
	elif current_state == GhostState.STARTING_AT_HOME:
		move_to_next_home_position()

func move_to_next_home_position():
	# Alternate between home positions
	current_at_home_index = 1 if current_at_home_index == 0 else 0 
	navigation_agent_2d.target_position = movement_targets.at_home_targets[current_at_home_index].position
	
func chase_position_reached():
	# Placeholder for chase logic
	print("KILL PACMAN")
	
func scatter_position_reached():
	print(current_scatter_index)
	if current_scatter_index < 3:
		current_scatter_index += 1
	else:
		current_scatter_index = 0
	print(current_scatter_index)
		
	navigation_agent_2d.target_position = movement_targets.scatter_targets[current_scatter_index].position

func _on_scatter_timer_timeout():
	# Transition from scatter to chase
	start_chasing_pacman()

func start_chasing_pacman():
	# Begin chasing Pac-Man
	if chasing_target == null:
		print("NO CHASING TARGET. CHASING WILL NOT WORK!!!")
	current_state = GhostState.CHASE
	update_chasing_target_position_timer.start()
	navigation_agent_2d.target_position = chasing_target.position
	calculate_path_to_target(chasing_target.position)

func _on_update_chasing_target_position_time_timeout():
	navigation_agent_2d.target_position = chasing_target.position
	# Periodically update chasing target
	calculate_path_to_target(chasing_target.position)

func start_chasing_pacman_after_being_eaten():
	# Resume chasing after being eaten
	start_chasing_pacman()
	body_sprite.show()
	body_sprite.move()
	
func run_away_from_pacman():
	# Handle "run away" behavior
	if run_away_timer.is_stopped():
		body_sprite.run_away()
		eyes_sprite.hide_eyes()
		run_away_timer.start()
	current_state = GhostState.RUN_AWAY
	update_chasing_target_position_timer.stop()
	scatter_timer.stop()
	
	var empty_cell_position = tile_map.get_random_empty_cell_position()
	navigation_agent_2d.target_position = empty_cell_position

func start_blinking():
	# Start blinking animation
	body_sprite.start_blinking()
	
func _on_run_away_timer_timeout():
	# End "run away" behavior
	run_away_timeout.emit()
	is_blinking = false
	eyes_sprite.show_eyes()
	body_sprite.move()
	start_chasing_pacman()

func get_eaten():
	# Handle ghost being eaten
	body_sprite.hide()
	eyes_sprite.show_eyes()
	points_label.show()
	points_label.text = "%d" % points_manager.points_for_ghost_eaten
	await points_manager.pause_on_ghost_eaten()
	points_label.hide()
	run_away_timer.stop()
	run_away_timeout.emit()
	current_state = GhostState.EATEN
	navigation_agent_2d.target_position = movement_targets.at_home_targets[0].position

func _on_body_entered(body):
	# Handle collision with Pac-Man
	var player = body as Player
	if current_state == GhostState.RUN_AWAY:
		get_eaten()
	elif current_state == GhostState.CHASE or current_state == GhostState.SCATTER:
		set_collision_mask_value(1, false)
		update_chasing_target_position_timer.stop()
		
		#Player collision conditionals
		if player.is_powered == false:
			player.die() #<--- this still works as intended
		else:
			get_eaten() #<--- inconsistent, might need to fix RUN_AWAY state
		
		scatter_timer.wait_time = 600
		scatter()
		
func calculate_path_to_target(target_position: Vector2):
	# Pathfinding logic based on ghost type
	match ghost_type:
		"scarlet":  # Greedy pathfinding (A*)
			navigation_agent_2d.target_position = target_position
		"blush":  # Prediction-based pathfinding
			var pacman_velocity = chasing_target.velocity 
			var prediction_offset = pacman_velocity.normalized() * 4 * tile_map.get_cell_size().x
			navigation_agent_2d.target_position = chasing_target.position + prediction_offset
		"azure":  # Combined targeting
			var scarlet_position = movement_targets.get_scarlet_position(get_parent())
			var midpoint = (scarlet_position + chasing_target.position) / 2
			navigation_agent_2d.target_position = midpoint
		"amber":  # Proximity-based switching
			if global_position.distance_to(chasing_target.position) < 5 * tile_map.get_cell_size().x:
				navigation_agent_2d.target_position = chasing_target.position
			else:
				navigation_agent_2d.target_position = tile_map.get_random_empty_cell()

