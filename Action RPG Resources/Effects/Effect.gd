extends AnimatedSprite #scripts have to extend the node they are attached to

func _ready():
	connect("animation_finished", self, "_on_animation_finished") #if different object with signal self.connect is required, "self" in this case, is the object
	frame = 0
	play("Animate")

func _on_animation_finished():
	queue_free()
