extends RigidBody2D

var _queue_teleport = Vector2.ZERO

var _last_move_dir: Vector2

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if _queue_teleport != Vector2.ZERO:
		state.transform = Transform2D(0.0, _queue_teleport)
		state.linear_velocity = Vector2.ZERO # also only edit linear_velocity in _integrate_forces
		_queue_teleport = Vector2.ZERO

func _ready() -> void:
	$ZOrdering.init($Sprite2D)

func die() -> void:
	EventBus.level_reset.emit(0)
	Inventory.clear()

func queue_teleport(pos: Vector2) -> void:
	_queue_teleport = pos

func teleport(pos: Vector2) -> void:
	position = pos
	linear_velocity = Vector2.ZERO

func set_last_move_dir(dir: Vector2) -> void:
	_last_move_dir = dir

func get_last_move_dir() -> Vector2:
	return _last_move_dir
