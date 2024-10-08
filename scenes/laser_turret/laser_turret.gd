extends RayCast2D

var last_collider: Object

func _ready() -> void:
	$ZOrdering.init($Sprite2D)
	$Laser.visible = false

func _physics_process(_delta: float) -> void:
	if not is_colliding():
		last_collider = null
		return
	
	var collision_point = get_collision_point()
	var distance = transform.origin.distance_to(collision_point)
	
	$Laser.scale.x = distance / 64
	
	var found_collider = get_collider()
	
	if found_collider != last_collider:
		last_collider = found_collider
		if found_collider == RoomManager.get_player():
			RoomManager.get_player().die()
		# do hit stuff here
