extends Node

var pacman_speed = 100
var ghost_speed = 80
var frightened_duration = 10
var is_frightened = false 
var level = 1  # Start at level 1

# Speed and timing settings for each level
var level_speeds = {
	1: 80,
	2: 85,
	3: 90,
	4: 95,
	5: 100,
	6: 105,
	7: 110,
	8: 115,
	9: 120,
	10: 125,
	11: 130,
	12: 135,
	13: 140,
	14: 145,
	15: 150,
	16: 155,
	17: 160,
	18: 165,
	19: 170,
	20: 175,  # Max speed at level 20
}

var level_times = {
	1: 60.0,  # Time allowed per level (in seconds)
	2: 59.0,
	3: 58.0,
	4: 57.0,
	5: 56.0,
	6: 55.0,
	7: 54.0,
	8: 53.0,
	9: 52.0,
	10: 51.0,
	11: 50.0,
	12: 49.0,
	13: 48.0,
	14: 47.0,
	15: 46.0,
	16: 45.0,
	17: 44.0,
	18: 43.0,
	19: 42.0,
	20: 41.0,  # Min time at level 20
}

# Initialize with the first level's settings
func _ready():
	set_level(level)

func set_level(new_level):
	level = new_level
	ghost_speed = level_speeds.get(level, 80)  # Default to 80 if level isn't found
	pacman_speed = 100 + (level - 1) * 2  # Increment Pac-Man speed as levels increase
	var level_time = level_times.get(level, 60.0)  # Default to 60 seconds if level isn't found

# Function to call when level progresses
func next_level():
	level += 1
	if level <= 20:
		set_level(level)  # Set new level parameters
	else:
		print("Game Over! You've completed all 20 levels.")

# Handle the frightened state
func set_frightened_state(frightened: bool):
	is_frightened = frightened
	if is_frightened:
		# When frightened, reduce ghost speed (for example, by half)
		ghost_speed = ghost_speed / 2
		print("Ghosts are frightened!")
	else:
		# Reset ghost speed after the frightened state ends
		ghost_speed = level_speeds.get(level, 80)  # Reset to current level's speed
		print("Ghosts are no longer frightened.")

# Function to handle the frightened state timer
func _process(delta):
	if is_frightened:
		frightened_duration -= delta
		if frightened_duration <= 0:
			set_frightened_state(false)  # Disable frightened state after the duration
