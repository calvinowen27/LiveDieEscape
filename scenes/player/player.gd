extends RigidBody2D

var _queue_teleport = Vector2.ZERO

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
