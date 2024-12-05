extends Area2D

@export var pac_man : CharacterBody2D
@onready var score_system = $"../Score"

	
func _on_body_entered(body):
	if body == pac_man:
		score_system.update_score(50)
		pac_man.powerup()
		queue_free()
