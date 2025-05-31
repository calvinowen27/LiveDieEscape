extends RigidBody2D

@export var _item: Area2D

var _item_in_range: bool = true
var _item_picked_up: bool = false

var _player_in_range: bool = false

var _queue_teleport = Vector2.ZERO

@onready var _start_pos: Vector2 = position

@onready var _state: GuardState = $GuardState

func _ready() -> void:
	EventBus.item_pickup.connect(_on_item_pickup)

# queue teleport teleports the guard when it's safe (due to rigidbody constraints)
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if _queue_teleport != Vector2.ZERO:
		state.transform = Transform2D(0.0, _queue_teleport)
		state.linear_velocity = Vector2.ZERO
		_queue_teleport = Vector2.ZERO

func queue_teleport(pos: Vector2) -> void:
	_queue_teleport = pos

func queue_reset() -> void:
	queue_teleport(_start_pos)

func get_start_pos() -> Vector2:
	return _start_pos

func get_item() -> Area2D:
	return _item

func _on_item_pickup(item: Item) -> void:
	if item == _item:
		_item_picked_up = true

func _on_guard_area_body_entered(body: Node) -> void:
	if body == RoomManager.get_player():
		_player_in_range = true

func _on_guard_area_body_exited(body: Node) -> void:
	if body == RoomManager.get_player():
		_player_in_range = false

func _on_guard_area_area_entered(area: Area2D) -> void:
	if area == _item:
		_item_in_range = true

func _on_guard_area_area_exited(area: Area2D) -> void:
	if area == _item:
		_item_in_range = false

func _on_disruptable_disruption(disruptor:Disruptor) -> void:
	_state.disrupt(disruptor)

func player_in_range() -> bool:
	return _player_in_range

func item_in_range() -> bool:
	return _item_in_range

func item_picked_up() -> bool:
	return _item == null or _item_picked_up
