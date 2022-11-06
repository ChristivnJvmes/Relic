extends AnimatedSprite

func _ready():
	connect("animation_finished", self,"_on_animation_finsished")
	play("Animate")
	
func _on_animation_finsished():
	queue_free()
