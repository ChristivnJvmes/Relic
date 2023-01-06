extends Area2D

var player = null

func can_see_player(): #this function defines wether the bat can see the player
	return player != null

func _on_PlayerDetectionZone_body_entered(body): #makes player the target
	player = body


func _on_PlayerDetectionZone_body_exited(body): #de-aggros
	player = null
