extends Area2D

const HitEffect = preload("res://Action RPG Resources/Effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_Timer_timeout():
	self.invincible = false #have to call self because setter won't activate otherwise

func _on_HurtBox_invincibility_started(): #These functions de activate hurtbox when invincible then re enable
	set_deferred("monitoring", false)

func _on_HurtBox_invincibility_ended():
	monitoring = true
