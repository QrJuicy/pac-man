extends Node

var ghost_global_clock = 0

@export_group("Scarlet")
@export var scarlet_ghost : Area2D
@export var scarlet_start_time : float

@export_group("Blush")
@export var blush_ghost : Area2D
@export var blush_start_time : float

@export_group("Azure")
@export var azure_ghost : Area2D
@export var azure_start_time : float

@export_group("Amber")
@export var amber_ghost : Area2D
@export var amber_start_time : float

@onready var player = $"../PacMan" as Player

func _ready():
	player.player_died.connect(reset_ghosts)
	
func _process(delta):
	ghost_global_clock+=1
	ghost_activation_stack()

func reset_ghosts(lifes):	
	var ghosts = get_children() as Array[Ghost]
	if lifes == 0:
		for ghost in ghosts:
			ghost.scatter_timer.stop()
			ghost.scatter_timer.wait_time = 10000
			ghost.scatter_timer.start()
			ghost.current_state = Ghost.GhostState.SCATTER
	else:		
		for ghost in ghosts:
			ghost.setup()
	
func ghost_activation_stack():
	if ghost_global_clock == scarlet_start_time:
		scarlet_ghost.process_mode = Node.PROCESS_MODE_INHERIT
	if ghost_global_clock == blush_start_time:
		blush_ghost.process_mode = Node.PROCESS_MODE_INHERIT
	if ghost_global_clock == azure_start_time:
		azure_ghost.process_mode = Node.PROCESS_MODE_INHERIT
	if ghost_global_clock == amber_start_time:
		amber_ghost.process_mode = Node.PROCESS_MODE_INHERIT
