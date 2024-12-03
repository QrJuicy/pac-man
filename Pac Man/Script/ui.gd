extends CanvasLayer

class_name UI

signal update_ghost_state(new_state)

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
