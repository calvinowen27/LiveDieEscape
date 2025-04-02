extends RigidBody2D

class_name LaserTurret

const TWO_PI = 2*PI

var _item_dropped: bool = false

@export var _start_rotation: int
@export var _movable: bool = false
@export var _rotating: bool = false

func _ready() -> void:
	# $ZOrdering.init($Sprite2D)
	$RayCast2D/Laser.visible = false

	# $RayCast2D/Laser/ZOrdering.init_marker($RayCast2D/Laser, $RayCast2D/Laser/ZOrderingMarker)

	$ForceFieldInteractable.set_active(false)
	$ScrapInteractable.set_active(false)

	$ControlInteractable.set_active(_rotating)

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
	if $LaserTurretState.is_broken():
		return
	
	$LaserTurretState.die()
	$ScrapInteractable.set_active(true)

func enable_turret() -> void:
	$LaserTurretState.enable_turret()
	
	$ForceFieldInteractable.set_active(false)

# drop force field emitter if haven't already
# func _on_interactable_interact() -> void:
# 	var ff = $ForceFieldWorld
# 	remove_child(ff)
# 	ff.queue_free()

# 	_item_dropped = true

# 	RoomManager.instantiate_item("force_field_emitter", position + Vector2(0, 60))

func _on_control_interactable_interact() -> void:
	if not _rotating:
		return
	
	# spawn control chip
	var control_chip = RoomManager.instantiate_item("control_chip", position + Vector2(0, 60))
	control_chip.set_control(RoomManager.get_curr_level(), RoomManager.get_curr_room_idx())
	
	disable_turret()

# drop force field emitter if haven't already
func _on_force_field_interactable_interact() -> void:
	var ff = $ForceFieldWorld
	remove_child(ff)
	ff.queue_free()

	_item_dropped = true

	RoomManager.instantiate_item("force_field_emitter", position + Vector2(0, 60))

	Fabricator.learn_recipe("Force Field Emitter")
	$ForceFieldInteractable.set_active(false)

func _on_scrap_interactable_interact() -> void:
	Fabricator.add_material("scrap", 5)
	Fabricator.add_material("antenna", 1)
	$ScrapInteractable.set_active(false)

func get_start_rotation() -> int:
	return _start_rotation

func is_movable() -> bool:
	return _movable

func is_rotating() -> bool:
	return _rotating;
