extends LaserTurret

func _process(delta: float) -> void:
	rotation += delta
	if rotation >= 2 * PI:
		rotation = 0