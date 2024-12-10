extends RigidBody2D

class_name LaserTurret

const TWO_PI = 2*PI

var _item_dropped: bool = false

@export var _start_rotation: int
@export var _movable: bool = false

func _ready() -> void:
	$ZOrdering.init($Sprite2D)
	$RayCast2D/Laser.visible = false

	# $RayCast2D/Laser/ZOrdering.init_marker($RayCast2D/Laser, $RayCast2D/Laser/ZOrderingMarker)

	$Interactable.set_active(false)

	var rotation_rads = (_start_rotation % 360) * TWO_PI / 360

	# if rotation_rads != 0:
	# 	$Sprite2D/Spark.visible = true
	# 	$Sprite2D.frame_coords = Vector2i((int)((rotation_rads / TWO_PI) * 22), 7)
	# 	print($Sprite2D.frame_coords)
	
	$RayCast2D/Laser.rotation = rotation_rads
	var laser_raycast = $RayCast2D
	laser_raycast.position = $CenterMarker.position + Vector2(-cos(rotation_rads) * 8, 0)
	$Sprite2D/Spark.position.x = $CenterMarker.position.x - cos(rotation_rads) * 8
	laser_raycast.target_position = laser_raycast.position + Vector2(-cos(rotation_rads) * 1000, -sin(rotation_rads) * 1000)

	if $RayCast2D/Laser/ZOrderingMarker.global_position.y > $Sprite2D.global_position.y:
		$RayCast2D/Laser.z_index = 4096
	else:
		$RayCast2D/Laser.z_index = 0
	
func reboot() -> void:
	$LaserTurretState.reboot()

func disable_turret() -> void:
	$LaserTurretState.disable_turret()

	if not _item_dropped:
		$Interactable.set_active(true)

func die() -> void:
	$LaserTurretState.die()

func enable_turret() -> void:
	$LaserTurretState.enable_turret()
	
	$Interactable.set_active(false)

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