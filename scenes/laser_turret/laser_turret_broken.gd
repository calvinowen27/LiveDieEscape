extends LaserTurretState

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func update(_delta: float) -> String:
	# unredeemable
	return name

func laser_turret_state_enable(turret: LaserTurret, animation_player: AnimationPlayer, laser_sprite: Sprite2D, laser_raycast: RayCast2D) -> void:
	super.laser_turret_state_enable(turret, animation_player, laser_sprite, laser_raycast)
	
	# set state properties
	_laser_sprite.visible = false
	_laser_raycast.enabled = false

	_laser_raycast.get_node("Spark").visible = false
	_laser_raycast.get_node("SparkEnd").visible = false

	_turret.set_scrap_accessible(true)
	_turret.set_force_field_accessible(false)
	_turret.set_ID_accessible(false)
	
	# remove force field
	_turret.try_destroy_force_field()

	animation_player.play("laser_turret_broken")
