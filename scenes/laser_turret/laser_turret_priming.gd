extends LaserTurretState

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func laser_turret_state_enable(turret: LaserTurret, animation_player: AnimationPlayer, laser_sprite: Sprite2D, laser_raycast: RayCast2D) -> void:
	super.laser_turret_state_enable(turret, animation_player, laser_sprite, laser_raycast)

	_turret.set_ID_accessible(false)
	_turret.set_force_field_penetrable(false)

	_laser_sprite.visible = false
	_laser_raycast.enabled = false

	_turret.set_force_field_accessible(false)
	_turret.set_scrap_accessible(false)
	
	animation_player.play("laser_turret_priming")

	var rotation_rads = (_turret.get_start_rotation() % 360) * TWO_PI / 360

	if rotation_rads != 0:
		_laser_raycast.get_node("SparkEnd").visible = false
		_laser_raycast.get_node("Spark").visible = false
		_turret.get_node("Sprite2D").frame_coords = Vector2i((int)((rotation_rads / TWO_PI) * 8), 0)
