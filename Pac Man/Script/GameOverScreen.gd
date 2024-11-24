extends Control

func _ready():
	# Ensure the screen is initially hidden
	visible = false

# Show the Game Over screen
func show_game_over():
	visible = true  # Make the screen visible
	get_tree().paused = true  # Pause the game (optional)

# Try the game again
func _on_try_again_pressed():
	get_tree().reload_current_scene()  # Reload the current scene
	get_tree().paused = false  # Unpause the game

# Quit the game
func _on_quit_pressed():
	get_tree().quit()  # Quit the application
