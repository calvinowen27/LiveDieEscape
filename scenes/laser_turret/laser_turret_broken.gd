extends LaserTurretState

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func update(_delta: float) -> String:
	# unredeemable
	return name

func laser_turret_state_enable(animation_player: AnimationPlayer, laser_sprite: Sprite2D, laser_raycast: RayCast2D) -> void:
	super.laser_turret_state_enable(animation_player, laser_sprite, laser_raycast)
	
	animation_player.play("laser_turret_broken")

	animation_player.speed_scale = 1
