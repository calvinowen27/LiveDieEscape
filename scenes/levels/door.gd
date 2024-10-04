extends Area2D

var _room_idx = 0
@export var next_level: int
@export var next_room: int
@export var next_door: int

@export var locked = false

func _ready() -> void:
	_room_idx = RoomManager.get_curr_room_idx()

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body == RoomManager.get_player() and not locked:
		RoomManager.set_curr_room(next_level, next_room)

func unlock() -> void:
	locked = false

func get_room_idx() -> int:
	return _room_idx
