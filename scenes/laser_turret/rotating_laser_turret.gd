extends LaserTurret

# func _ready() -> void:
# 	$ZOrdering.init($Sprite2D)
# 	$RayCast2D/Laser.visible = false

# 	$Interactable

# func _on_interactable_interact() -> void:
# 	# spawn control chip
# 	if $LaserTurretState.get_curr_state().name == "LaserTurretActivated":
# 		var control_chip = RoomManager.instantiate_item("control_chip", position + Vector2(0, 50))
# 		control_chip.set_control(RoomManager.get_curr_level(), RoomManager.get_curr_room_idx())
	
# 	$LaserTurretState.disable_turret()

# func disable_turret() -> void:
# 	$LaserTurretState.disable_turret()

# func enable_turret() -> void:
# 	$LaserTurretState.enable_turret()


func _on_control_interactable_interact() -> void:
	# spawn control chip
	if $LaserTurretState.get_curr_state().name == "LaserTurretActivated":
		var control_chip = RoomManager.instantiate_item("control_chip", position + Vector2(0, 50))
		control_chip.set_control(RoomManager.get_curr_level(), RoomManager.get_curr_room_idx())
	
	disable_turret()
