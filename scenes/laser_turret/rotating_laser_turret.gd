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

func reboot() -> void:
	$RotatingLaserTurretState.reboot()

func disable_turret() -> void:
	$RotatingLaserTurretState.disable_turret()

	if not _item_dropped:
		$ForceFieldInteractable.set_active(true)

func die() -> void:
	$RotatingLaserTurretState.die()

func enable_turret() -> void:
	$RotatingLaserTurretState.enable_turret()
	
	$ForceFieldInteractable.set_active(false)


func _on_control_interactable_interact() -> void:
	# spawn control chip
	var control_chip = RoomManager.instantiate_item("control_chip", position + Vector2(0, 60))
	control_chip.set_control(RoomManager.get_curr_level(), RoomManager.get_curr_room_idx())
	
	disable_turret()


func _on_force_field_interactable_interact() -> void:
	var ff = $ForceFieldWorld
	remove_child(ff)
	ff.queue_free()

	_item_dropped = true

	RoomManager.instantiate_item("force_field_emitter", position + Vector2(0, 60))
