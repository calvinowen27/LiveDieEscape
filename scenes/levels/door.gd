extends Area2D

class_name Door

var _room_idx = 0
@export var _next_level: int
@export var _next_room: int
@export var _next_door: int

@export var locked = false

var _activated = false # if door can be used

func _init() -> void:
	EventBus.change_room.connect(_on_room_change)

func _ready() -> void:
	_room_idx = RoomManager.get_curr_room_idx()

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if _activated and body == RoomManager.get_player() and not locked:
		RoomManager.set_curr_room(_next_level, _next_room, self)
		_activated = false

func _on_room_change(level_idx: int, room_idx: int) -> void:
	var parent_room = get_parent()
	if parent_room.get_level_idx() == level_idx and parent_room.get_room_idx() == room_idx:
		start_activation()

func start_activation() -> void:
	$ActivationTimer.start()

func _on_activation_timer_timeout() -> void:
	_activated = true

func get_next_door() -> int:
	return _next_door

func unlock() -> void:
	locked = false

func get_room_idx() -> int:
	return _room_idx
