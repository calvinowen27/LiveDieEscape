extends LaserTurretState

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func laser_turret_state_enable(turret: LaserTurret, animation_player: AnimationPlayer, laser_sprite: Sprite2D, laser_raycast: RayCast2D) -> void:
	super.laser_turret_state_enable(turret, animation_player, laser_sprite, laser_raycast)
	
	laser_sprite.visible = true
	laser_raycast.enabled = true

	var rotation_rads = (_turret.get_start_rotation() % 360) * TWO_PI / 360

	# get_node("../../").freeze = false

	if rotation_rads != 0:
		_turret.get_node("Sprite2D/Spark").visible = true
		_turret.get_node("Sprite2D").frame_coords = Vector2i((int)((rotation_rads / TWO_PI) * 22) + 2, 7)
		animation_player.play("laser_turret_spark")
	else:
		animation_player.play("laser_turret_activated")
