extends Area2D

func _on_body_entered(body:Node2D) -> void:
	var player = RoomManager.get_player()
	if body == player:
		self.queue_free()

		PowerupManager.add_powerup("speed")