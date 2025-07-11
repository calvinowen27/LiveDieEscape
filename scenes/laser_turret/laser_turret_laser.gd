extends RayCast2D

var last_collider: Object

# note to self make sure script is actually attached in the editor

# func _ready() -> void:
# 	$ZOrdering.init($Laser)

func _physics_process(_delta: float) -> void:
	if not is_colliding():
		last_collider = null
		return
	
	var collision_point = get_collision_point()
	var distance = global_position.distance_to(collision_point)
	
	# actually works idk why i was surprised
	$Laser.global_position = collision_point
	$Laser.scale.x = -distance / (64 * global_scale.x) # 64 is pixel width of laser sprite
	$SparkEnd.global_position = collision_point
	
	var found_collider = get_collider()
	
	if found_collider != last_collider:
		last_collider = found_collider
		if found_collider == RoomManager.get_player():
			RoomManager.get_player().die()
		elif found_collider is LaserTurret:
			found_collider.die()
		elif found_collider is Disruptor:
			found_collider.die()
		# do hit stuff here
