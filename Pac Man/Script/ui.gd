extends CanvasLayer

class_name UI

signal update_ghost_state(new_state)
signal next_level_requested

@onready var center_container = $MarginContainer/CenterContainer
@onready var center_container_2 = $MarginContainer/CenterContainer2
@onready var life_count_label = %LifeCountLabel
@onready var game_score_label = %GameScoreLabel
@onready var game_label = $MarginContainer/CenterContainer/Panel/GameLabel
@onready var game_label_2 = $MarginContainer/CenterContainer2/Panel2/GameLabel2

func set_lifes(lifes: int):
	# Update life count and handle game over condition
	life_count_label.text = "%d up" % lifes
	if lifes <= 0:
		game_lost()

func set_score(score: int):
	# Update the score displayed on the UI
	game_score_label.text = "SCORE: %d" % score

func game_won():
	# Show the "Game Won" message
	center_container.show()  # Display the center container for game win
	center_container_2.hide()  # Hide the game over container (if shown)

func game_lost():
	# Show the "Game Over" message
	center_container_2.show()  # Display the container for game over
	center_container.hide()  # Hide the game win container (if shown)

func _on_restart_button_pressed():
	# Reload the current scene to restart the game
	get_tree().reload_current_scene()

func _on_next_level_button_pressed():
	# Emit a signal to load the next level (to be handled by another script)
	emit_signal("next_level_requested")

func _on_main_menu_button_pressed():
	# Load the main menu scene
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_try_again_button_pressed():
	# Reload the current scene and unpause the game
	get_tree().reload_current_scene()
	get_tree().paused = false
