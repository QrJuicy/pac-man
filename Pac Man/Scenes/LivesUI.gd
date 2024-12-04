extends Node

# Export variables for the life images (TextureRect nodes)
@onready var life1 = $"Horizontal lives/LIFE1"
@onready var life2 = $"Horizontal lives/LIFE2"
@onready var life3 = $"Horizontal lives/LIFE3"


var max_lives = 3
var current_lives = max_lives

# Function to update the life display based on the current lives
func update_lives():
	life1.texture = preload("res://Main Assets/Pacman/Pacman_02.png")
	life2.texture = preload("res://Main Assets/Pacman/Pacman_02.png")
	life3.texture = preload("res://Main Assets/Pacman/Pacman_02.png")

	# Change texture to empty for lost lives
	if current_lives < 3:
		life1.texture = preload("res://Main Assets/Pacman/Pacman_Death_11.png")
	if current_lives < 2:
		life2.texture = preload("res://Main Assets/Pacman/Pacman_Death_11.png")
	if current_lives < 1:
		life3.texture = preload("res://Main Assets/Pacman/Pacman_Death_11.png")
