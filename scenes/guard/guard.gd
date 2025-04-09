extends RigidBody2D

@export var _key: Area2D

var _key_in_range: bool = true
var _key_picked_up: bool = false
var _player_in_range: bool = false

var _queue_teleport = Vector2.ZERO

func _ready() -> void:
	EventBus.item_pickup.connect(_on_item_pickup)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if _queue_teleport != Vector2.ZERO:
		state.transform = Transform2D(0.0, _queue_teleport)
		state.linear_velocity = Vector2.ZERO # also only edit linear_velocity in _integrate_forces
		_queue_teleport = Vector2.ZERO

func queue_teleport(pos: Vector2) -> void:
	_queue_teleport = pos

func get_key() -> Area2D:
	return _key

func _on_item_pickup(item: Item) -> void:
	if item == _key:
		_key_picked_up = true

func _on_guard_area_body_entered(body: Node) -> void:
	if body == RoomManager.get_player():
		_player_in_range = true

func _on_guard_area_body_exited(body: Node) -> void:
	if body == RoomManager.get_player():
		_player_in_range = false

func _on_guard_area_area_entered(area: Area2D) -> void:
	if area == _key:
		_key_in_range = true

func _on_guard_area_area_exited(area: Area2D) -> void:
	if area == _key:
		_key_in_range = false

func player_in_range() -> bool:
	return _player_in_range

func key_in_range() -> bool:
	return _key_in_range

func key_picked_up() -> bool:
	return _key_picked_up
