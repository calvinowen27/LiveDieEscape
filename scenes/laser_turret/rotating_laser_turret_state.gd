extends LaserTurretState

# activate turret when finished priming
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "rotating_laser_turret_priming":
		_set_curr_state("RotatingLaserTurretActivated")
	elif anim_name == "rotating_laser_turret_breaking":
		_set_curr_state("RotatingLaserTurretBroken")

func _on_room_change(level_idx: int, room_idx: int) -> void:
	if _curr_state == null:
		return
	
	if (level_idx != _level or room_idx != _room) and _curr_state.name != "RotatingLaserTurretBroken" and _curr_state.name != "RotatingLaserTurretBreaking":
		get_parent().disable_turret()
		get_parent().enable_turret()

func reboot() -> void:
	pass
	# _set_curr_state("RotatingLaserTurretIdle")
	
	# await get_tree().create_timer(10).timeout
	
	# if _curr_state.name == "RotatingLaserTurretIdle":
	# 	_set_curr_state("RotatingLaserTurretPriming")


func start_reboot() -> void:
	if not _is_broken():
		_set_curr_state("RotatingLaserTurretRebooting")

func end_reboot() -> void:
	if not _is_broken() and _curr_state.name == "RotatingLaserTurretRebooting":
		_set_curr_state("RotatingLaserTurretPriming")
	
func disable_turret() -> void:
	if _curr_state.name != "RotatingLaserTurretBroken" and _curr_state.name != "RotatingLaserTurretBreaking":
		_set_curr_state("RotatingLaserTurretIdle")

func enable_turret() -> void:
	if _curr_state.name != "RotatingLaserTurretBroken" and _curr_state.name != "RotatingLaserTurretBreaking":
		_set_curr_state("RotatingLaserTurretPriming")

func die() -> void:
	if _curr_state.name != "RotatingLaserTurretBroken" and _curr_state.name != "RotatingLaserTurretBreaking":
		_set_curr_state("RotatingLaserTurretBreaking")
