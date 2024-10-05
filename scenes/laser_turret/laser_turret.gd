extends RayCast2D

var last_collider: Object

func _ready() -> void:
	$ZOrdering.init($Sprite2D)
	$Laser.visible = false

func _physics_process(delta: float) -> void:
	if not is_colliding():
		last_collider = null
		return
	
	var collision_point = get_collision_point()
	var distance = transform.origin.distance_to(collision_point)
	
	$Laser.scale.x = (distance - 14) / 64
	
	var found_collider = get_collider()
	
	if found_collider != last_collider:
		pass
		# do hit stuff here
