extends Area2D

func _on_body_entered(body:Node2D) -> void:
	if body == RoomManager.get_player():
		body.add_child(load("res://scenes/lightning_mine/lightning.tscn").instantiate())
	elif body is LaserTurret:
		body.add_child(load("res://scenes/lightning_mine/lightning.tscn").instantiate())
