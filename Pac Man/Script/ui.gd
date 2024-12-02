extends CanvasLayer

class_name UI

func _on_restart_button_pressed():
	# Reload the current level
	get_tree().reload_current_scene()

func _on_next_level_button_pressed():
	# Replace with logic to load the next level
	var next_scene = "res://Scenes/NextLevel.tscn"  # Update path
	get_tree().change_scene(next_scene)

func _on_main_menu_button_pressed():
	# Load the main menu
	var main_menu = "res://Scenes/main_menu.tscn"  # Update path
	get_tree().change_scene(main_menu)
