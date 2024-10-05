extends LaserTurretState


func laser_turret_state_enable(animated_sprite: AnimatedSprite2D) -> void:
	super.laser_turret_state_enable(animated_sprite)
	
	animated_sprite.animation = "laser_turret_activated"
	animated_sprite.play()
