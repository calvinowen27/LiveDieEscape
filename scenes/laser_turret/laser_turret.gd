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
@onready var _force_field: ForceField = $ForceField

func _ready() -> void:
	_next_id += 1

	var rotation_rads = deg_to_rad(_start_rotation % 360)
	
	# using rotation to calculate positions of everything, spark, raycast, etc.
	$RayCast2D/Laser.rotation = rotation_rads
	var laser_raycast = $RayCast2D
	laser_raycast.position = $CenterMarker.position + Vector2(-cos(rotation_rads) * _laser_center_offset.x, -sin(rotation_rads) * _laser_center_offset.y)
	$RayCast2D/Spark.global_position = laser_raycast.global_position
	laser_raycast.target_position = Vector2(-cos(rotation_rads) * _laser_raycast_length, -sin(rotation_rads) * _laser_raycast_length)

	# initial force field penetrable set
	set_force_field_penetrable(false)

## wrappers for state changing
func disable_turret() -> void:
	_state.disable_turret()

func enable_turret() -> void:
	_state.enable_turret()

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

## signals/state changes

# security ID is learned
func _on_id_interactable_interact() -> void:
	EventBus.learn_security_id.emit(_id)

# drop force field emitter if haven't already
func _on_force_field_salvage_interact() -> void:
	try_destroy_force_field()
	
	Fabricator.learn_recipe("Force Field Emitter")

	set_force_field_accessible(false)

func _on_disruptable_disruption(_disruptor: Disruptor) -> void:
	_state.disrupt()

func _on_disruptable_end_disruption(_disruptor: Disruptor) -> void:
	_state.enable_turret()

func _on_shockable_shock(_lightning: Lightning) -> void:
	_state.shock()

## set accessibility of interactables
func set_scrap_accessible(val: bool) -> void:
	$ScrapSalvage.set_active(val)

func set_ID_accessible(val: bool) -> void:
	var id_interactable = $IDInteractable
	if id_interactable != null and  val != id_interactable.is_active():
		id_interactable.set_active(val)

func set_force_field_accessible(val: bool) -> void:
	$ForceFieldSalvage.set_active(val)

## set if player can move through force field
func set_force_field_penetrable(val: bool) -> void:
	if _force_field != null and _force_field.is_penetrable() != val:
		_force_field.set_penetrable(val)
	
		if val:
			remove_collision_exception_with(_force_field.get_node("RigidBody2D"))
		else:
			add_collision_exception_with(_force_field.get_node("RigidBody2D"))

func get_start_rotation() -> int:
	return _start_rotation

func is_movable() -> bool:
	return _movable

func is_rotating() -> bool:
	return _rotating;

func get_id() -> int:
	return _id

func try_destroy_force_field() -> void:
	# destroy force field
	if has_node("ForceField"):
		var ff = $ForceField
		remove_child.bind(ff).call_deferred()
		ff.queue_free.call_deferred()

func get_force_field() -> ForceField:
	if not has_node("ForceField"): return null
	return $ForceField
