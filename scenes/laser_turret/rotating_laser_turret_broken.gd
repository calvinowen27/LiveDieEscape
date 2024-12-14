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

	_turret.get_node("Sprite2D/Spark").visible = false
	
	animation_player.play("rotating_laser_turret_broken")
