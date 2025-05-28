extends RigidBody2D

class_name LaserTurret

const TWO_PI = 2*PI

var _item_dropped: bool = false

@export var _start_rotation: int
@export var _movable: bool = false
@export var _rotating: bool = false

static var _next_id: int = 1
@onready var _id: int = _next_id

@onready var _state: LaserTurretState = $LaserTurretState

func _ready() -> void:
	# $ZOrdering.init($Sprite2D)
	$RayCast2D/Laser.visible = false

	_next_id += 1

	# $ControlInteractable.set_active(_rotating)

	var rotation_rads = (_start_rotation % 360) * TWO_PI / 360
	
	# using rotation to calculate positions of everything, spark, raycast, etc.
	$RayCast2D/Laser.rotation = rotation_rads
	var laser_raycast = $RayCast2D
	laser_raycast.position = $CenterMarker.position + Vector2(-cos(rotation_rads) * 7, -sin(rotation_rads) * 3)
	$RayCast2D/Spark.global_position = laser_raycast.global_position
	laser_raycast.target_position = Vector2(-cos(rotation_rads) * 1000, -sin(rotation_rads) * 1000)
	
func disable_turret() -> void:
	_state.disable_turret()

	if not _item_dropped:
		$ForceFieldInteractable.set_active(true)

func enable_turret() -> void:
	_state.enable_turret()
	
	$ForceFieldInteractable.set_active(false)

func shock() -> void:
	if _state.is_broken(): return

	_state.shock()

func toggle() -> void:
	if _state.is_broken(): return
	if _state.get_curr_state().name == "LaserTurretDisabled":
		_state.enable_turret()
	else:
		_state.disable_turret()

func die() -> void:
	if _state.is_broken(): return
	
	_state.die()

# security ID is learned
func _on_id_interactable_interact() -> void:
	EventBus.learn_security_id.emit(_id)

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

func set_ID_accessible(val: bool) -> void:
	if val != $IDInteractable.is_active():
		$IDInteractable.set_active(val)

func get_start_rotation() -> int:
	return _start_rotation

func is_movable() -> bool:
	return _movable

func is_rotating() -> bool:
	return _rotating;

func get_id() -> int:
	return _id

func get_force_field() -> ForceField:
	return $ForceFieldWorld
