extends Area2D


var entered = false

func _on_leftGate_body_entered(body: PhysicsBody2D):
	entered = true

func _on_leftGate_body_exited(body):
	entered = false

func _process(delta):
	if entered == true:
		get_tree().change_scene("res://leftWorld.tscn")
