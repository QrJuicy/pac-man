extends Sprite2D

@onready var animation_player = $"../AnimationPlayer"

func _ready():
	self.modulate = (get_parent() as Ghost).color
	animation_player.play("moving")
	
