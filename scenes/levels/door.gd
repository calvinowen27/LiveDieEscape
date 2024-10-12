extends Area2D

class_name Door

var _room_idx = 0
@export var _door_idx = 0
@export var _next_level_idx: int
@export var _next_room_idx: int
@export var _next_door_idx: int

@export var _locked = false
@export var _consume_key = false

var _player_in_range = false

var _activated = false # if door can be used

func _init() -> void:
	EventBus.change_room.connect(_on_room_change)

func _ready() -> void:
	_room_idx = RoomManager.get_curr_room_idx()
	
	if _locked:
		$CollisionShape2D/ColorRect.color = Color(1.0, 0.0, 0.0, 1.0)
	
	$InteractLabel.rotation = -rotation

func _process(_delta: float) -> void:
	if _locked and Input.is_action_just_pressed("interact"):
		attempt_open()

func attempt_open() -> void:
	if _activated and _player_in_range:
		var keys = Inventory.get_items_of_group("Keys")
		for key in keys:
			if key.unlocks_door(RoomManager.get_curr_level(), _room_idx, _door_idx):
				unlock()
				next_room()
				if _consume_key:
					Inventory.del_item(key)
				break

func next_room() -> void:
	RoomManager.set_curr_room(_next_level_idx, _next_room_idx, self)
	_activated = false

func _on_room_change(level_idx: int, room_idx: int) -> void:
	# if next room is this door's room, start activation timer for door
	var parent_room = get_parent()
	var valid = parent_room.is_valid()
	if valid and parent_room.get_level_idx() == level_idx and parent_room.get_room_idx() == room_idx:
		start_activation()

func start_activation() -> void:
	$ActivationTimer.start()

func _on_activation_timer_timeout() -> void:
	_activated = true

func get_next_door_idx() -> int:
	return _next_door_idx

func unlock() -> void:
	$CollisionShape2D/ColorRect.color = Color(1.0, 1.0, 1.0, 1.0)
	_locked = false
	$InteractLabel.visible = false

func is_locked() -> bool:
	return _locked

func get_room_idx() -> int:
	return _room_idx

func _on_interact_area_body_entered(body: Node2D) -> void:
	if body == RoomManager.get_player() and _locked:
		_player_in_range = true
		$InteractLabel.visible = true

func _on_interact_area_body_exited(body: Node2D) -> void:
	if body == RoomManager.get_player():
		_player_in_range = false
		$InteractLabel.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body == RoomManager.get_player() and not _locked:
		next_room()
