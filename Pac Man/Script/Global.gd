extends Node

signal level_changed

# Game parameters
var pacman_speed = 300
var ghost_speed = 120
var level = 1  # Start at level 1

# Speed settings for each level
var level_ghost_speed = {
	1: 120, 
	2: 125, 
	3: 130, 
	4: 135, 
	5: 140, 
	6: 145, 
	7: 150, 
	8: 155, 
	9: 160, 
	10: 165,
	11: 170, 
	12: 175, 
	13: 180, 
	14: 185, 
	15: 190, 
	16: 195, 
	17: 200, 
	18: 205, 
	19: 210, 
	20: 215
}

func _ready():
	set_level(level)

func set_level(new_level):
	level = new_level
	ghost_speed = level_ghost_speed.get(level, 80)
	pacman_speed = 100 + (level - 1) * 2
	emit_signal("level_changed")  # Notify other scripts of level change
	print("Level set to ", level, " with Ghost Speed: ", ghost_speed, " and Pac-Man Speed: ", pacman_speed)

func next_level():
	level += 1
	if level <= 20:
		set_level(level)
	else:
		print("Game Over! You've completed all 20 levels.")
