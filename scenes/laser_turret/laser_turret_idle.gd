extends LaserTurretState

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func laser_turret_state_enable(animated_sprite: AnimatedSprite2D) -> void:
	super.laser_turret_state_enable(animated_sprite)
	
	animated_sprite.animation = "laser_turret_idle"
	animated_sprite.play()

func update(delta: float) -> String:
	var dist = RoomManager.get_player().global_position.distance_to(get_parent().get_parent().global_position)
	if dist < 50:
		return "LaserTurretPriming"
	
	return name
