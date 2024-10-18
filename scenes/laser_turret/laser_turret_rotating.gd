extends LaserTurret

func _on_interactable_interact() -> void:
	$LaserTurretState.disable_turret()
	
	RoomManager.instantiate_item("control_chip", position + Vector2(0, 50))
