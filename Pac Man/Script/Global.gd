extends Node

# Game parameters
var pacman_speed = 100
var ghost_speed = 80
var frightened_duration = 10
var scatter_duration = 7  # Duration for scatter state
var is_frightened = false
var is_scatter = true  # Ghosts start in scatter mode
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
	1: 100.0,  # Time allowed per level (in seconds)
	2: 98.0,
	3: 96.0,
	4: 94.0,
	5: 92.0,
	6: 90.0,
	7: 88.0,
	8: 86.0,
	9: 84.0,
	10: 82.0,
	11: 80.0,
	12: 78.0,
	13: 76.0,
	14: 74.0,
	15: 72.0,
	16: 70.0,
	17: 68.0,
	18: 66.0,
	19: 64.0,
	20: 62.0,  # Min time at level 20
}

var scatter_timer = 0.0
var frightened_timer = 0.0

# Initialize with the first level's settings
func _ready():
	set_level(level)
	start_scatter_mode()  # Begin with scatter mode

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
		# When frightened, reduce ghost speed (e.g., by half)
		frightened_timer = frightened_duration
		ghost_speed = ghost_speed / 2
		is_scatter = false  # Disable scatter mode during frightened state
		print("Ghosts are frightened!")
	else:
		# Reset ghost speed after the frightened state ends
		ghost_speed = level_speeds.get(level, 80)  # Reset to current level's speed
		print("Ghosts are no longer frightened.")

# Function to handle scatter mode
func start_scatter_mode():
	is_scatter = true
	scatter_timer = scatter_duration
	print("Ghosts are scattering!")

func end_scatter_mode():
	is_scatter = false
	print("Scatter mode ended. Ghosts are now chasing!")

# Update the timers for frightened and scatter states
func _process(delta):
	# Handle frightened mode
	if is_frightened:
		frightened_timer -= delta
		if frightened_timer <= 0:
			set_frightened_state(false)  # Disable frightened state when timer ends

	# Handle scatter mode
	if not is_frightened and is_scatter:
		scatter_timer -= delta
		if scatter_timer <= 0:
			end_scatter_mode()  # End scatter mode when timer expires
