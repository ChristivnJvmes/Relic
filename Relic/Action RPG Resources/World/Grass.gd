extends Node2D

const GrassEffect = preload("res://Action RPG Resources/Effects/GrassEffect.tscn") #You can drag an drop from file system (bottom left)

func create_grass_effect():
	var grassEffect = GrassEffect.instance() #Scene (GrassEffect) has 'instance' of a node (grassEffect) 
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position

func _on_HurtBox_area_entered(area):
	create_grass_effect()
	queue_free()
#CTRL+W closes out the .gd files to the left
