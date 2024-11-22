extends Node

var level_time_left = 0.0
var timer_running = false

func _ready():
	level_time_left = Global.level_time_left  # Initialize with time left from Global.gd
	start_timer()

func start_timer():
	timer_running = true
	set_process(true)

func _process(delta):
	if timer_running:
		if level_time_left > 0:
			level_time_left -= delta  # Countdown the level time
			if level_time_left <= 0:
				level_time_left = 0
				handle_level_end()  # Handle when time's up
		print("Time left for level: ", level_time_left)

func handle_level_end():
	print("Level Time's Up!")
	# Transition to the next level
	Global.next_level()
	# Reset level time
	level_time_left = Global.level_time_left
	# You can add any logic to reset or update game state
