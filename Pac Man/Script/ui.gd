extends CanvasLayer

class_name UI

signal update_ghost_state(new_state)

@onready var center_container = $MarginContainer/CenterContainer
@onready var life_count_label = %LifeCountLabel
@onready var game_score_label = %GameScoreLabel
@onready var game_label = %GameLabel


func _on_restart_button_pressed():
	# Reload the current level
	get_tree().reload_current_scene()

func _on_next_level_button_pressed():
	# Replace with logic to load the next level
	emit_signal("next_level_requested")

func _on_main_menu_button_pressed():
	# Load the main menu
	var main_menu = "res://Scenes/main_menu.tscn"  # Update path
	get_tree().change_scene(main_menu)
	

func set_lifes(lifes):
	life_count_label.text = "%d up" % lifes
	if lifes == 0: 
		game_lost()

func set_score(score):
	game_score_label.text = "SCORE: %d" % score

func game_lost():
	game_label.text = "Game lost"
	center_container.show()

func game_won():
	game_label.text = "Game won"
	center_container.show()
