extends RigidBody2D

class_name LaserTurret

@export var _start_rotation: int
@export var _movable: bool = false
@export var _rotating: bool = false
@export var _laser_center_offset: Vector2 = Vector2(7, 3)
@export var _laser_raycast_length: float = 250

# increment _next_id every time a new turret is created, each turret has unique id
static var _next_id: int = 1
@onready var _id: int = _next_id

@onready var _state: LaserTurretState = $LaserTurretState
@onready var _force_field: ForceField = $ForceFieldWorld

func _ready() -> void:
	_next_id += 1

	var rotation_rads = deg_to_rad(_start_rotation % 360)
	
	# using rotation to calculate positions of everything, spark, raycast, etc.
	$RayCast2D/Laser.rotation = rotation_rads
	var laser_raycast = $RayCast2D
	laser_raycast.position = $CenterMarker.position + Vector2(-cos(rotation_rads) * _laser_center_offset.x, -sin(rotation_rads) * _laser_center_offset.y)
	$RayCast2D/Spark.global_position = laser_raycast.global_position
	laser_raycast.target_position = Vector2(-cos(rotation_rads) * _laser_raycast_length, -sin(rotation_rads) * _laser_raycast_length)

## wrappers for state changing
func disable_turret() -> void:
	_state.disable_turret()

func enable_turret() -> void:
	_state.enable_turret()

func shock() -> void:
	_state.shock()

# returns true if new state is enabled, false if new state is disabled
func toggle() -> bool:
	if _state.get_curr_state().name == "LaserTurretDisabled":
		_state.enable_turret()
		return true
	else:
		_state.disable_turret()
		return false

# break turret
func die() -> void:	
	_state.die()

# security ID is learned
func _on_id_interactable_interact() -> void:
	EventBus.learn_security_id.emit(_id)

# drop force field emitter if haven't already
func _on_force_field_interactable_interact() -> void:
	# destroy force field
	if has_node("ForceFieldWorld"):
		var ff = $ForceFieldWorld
		remove_child(ff)
		ff.queue_free()

	# give player force field materials
	Fabricator.learn_recipe("Force Field Emitter")
	Fabricator.add_material("force_field_emitter", 1)

	set_force_field_accessible(false)

# give player scrap
func _on_scrap_interactable_interact() -> void:
	Fabricator.add_material("scrap", 5)
	Fabricator.add_material("antenna", 1)

	set_scrap_accessible(false)

## set accessibility of interatables
func set_scrap_accessible(val: bool) -> void:
	var scrap_interactable = $ScrapInteractable
	if scrap_interactable != null and  val != scrap_interactable.is_active():
		scrap_interactable.set_active(val)

func set_ID_accessible(val: bool) -> void:
	var id_interactable = $IDInteractable
	if id_interactable != null and  val != id_interactable.is_active():
		id_interactable.set_active(val)

func set_force_field_accessible(val: bool) -> void:
	var force_field_interactable = $ForceFieldInteractable
	if force_field_interactable != null and val != force_field_interactable.is_active():
		force_field_interactable.set_active(val)

## set if player can move through force field
func set_force_field_penetrable(val: bool) -> void:
	if _force_field != null and _force_field.is_penetrable() != val:
		_force_field.set_penetrable(val)

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
