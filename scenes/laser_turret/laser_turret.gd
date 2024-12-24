extends RigidBody2D

class_name LaserTurret

const TWO_PI = 2*PI

var _item_dropped: bool = false

@export var _start_rotation: int
@export var _movable: bool = false

func _ready() -> void:
	# $ZOrdering.init($Sprite2D)
	$RayCast2D/Laser.visible = false

	# $RayCast2D/Laser/ZOrdering.init_marker($RayCast2D/Laser, $RayCast2D/Laser/ZOrderingMarker)

	$ForceFieldInteractable.set_active(false)

	var rotation_rads = (_start_rotation % 360) * TWO_PI / 360
	
	# using rotation to calculate positions of everything, spark, raycast, etc.
	$RayCast2D/Laser.rotation = rotation_rads
	var laser_raycast = $RayCast2D
	laser_raycast.position = $CenterMarker.position + Vector2(-cos(rotation_rads) * 44, -sin(rotation_rads) * 13)
	$Sprite2D/Spark.position = Vector2(2 - cos(rotation_rads) * 6, -sin(rotation_rads) * 3.5)
	laser_raycast.target_position = Vector2(-cos(rotation_rads) * 1000, -sin(rotation_rads) * 1000)

	# hacky z ordering, idk why the normal ZOrder node doesn't work here, but this works so ima leave it
	if (_start_rotation >= 180 and _start_rotation <= 360) or _start_rotation == 0:
		$RayCast2D/Laser.z_index = 4096
		$Sprite2D/Spark.z_index = 0
	else:
		$RayCast2D/Laser.z_index = 0
		$Sprite2D/Spark.z_index = -1
	
func reboot() -> void:
	$LaserTurretState.reboot()

func start_reboot() -> void:
	$LaserTurretState.start_reboot()

	if not _item_dropped:
		$ForceFieldInteractable.set_active(true)

func end_reboot() -> void:
	$LaserTurretState.end_reboot()

	$ForceFieldInteractable.set_active(false)

func disable_turret() -> void:
	$LaserTurretState.disable_turret()

	if not _item_dropped:
		$ForceFieldInteractable.set_active(true)

func die() -> void:
	$LaserTurretState.die()

func enable_turret() -> void:
	$LaserTurretState.enable_turret()
	
	$ForceFieldInteractable.set_active(false)

# drop force field emitter if haven't already
func _on_interactable_interact() -> void:
	var ff = $ForceFieldWorld
	remove_child(ff)
	ff.queue_free()

	_item_dropped = true

	RoomManager.instantiate_item("force_field_emitter", position + Vector2(0, 60))

func get_start_rotation() -> int:
	return _start_rotation

func is_movable() -> bool:
	return _movable
