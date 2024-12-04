extends Node2D

@onready var pac_man = $"../PacMan" as Player

func _ready():
	pac_man.player_died.connect(reset_ghosts)

func reset_ghosts():
	var ghosts = get_children() as Array[Ghost]
	for ghost in ghosts:
		ghost.setup()
