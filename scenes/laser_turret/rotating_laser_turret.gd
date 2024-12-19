extends LaserTurret

func reboot() -> void:
	$RotatingLaserTurretState.reboot()

func start_reboot() -> void:
	$RotatingLaserTurretState.start_reboot()

	if not _item_dropped:
		$ForceFieldInteractable.set_active(true)

func end_reboot() -> void:
	$RotatingLaserTurretState.end_reboot()

	$ForceFieldInteractable.set_active(false)

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
