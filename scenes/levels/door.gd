extends Area2D

class_name Door

var _room_idx = 0
@export var _door_idx = 0
@export var _next_level_idx: int
@export var _next_room_idx: int
@export var _next_door_idx: int

@export var _locked = false
@export var _consume_key = false

var _active = false # if door can be used

func _init() -> void:
	EventBus.change_room.connect(_on_room_change)
	
func _ready() -> void:
	_room_idx = RoomManager.get_curr_room_idx()
	
	$Interactable.interact.connect(attempt_open)
	$Interactable.set_active(_locked)
	
	if _locked:
		$CollisionShape2D/ColorRect.color = Color(1.0, 0.0, 0.0, 1.0)

func attempt_open() -> void:
	if _active:
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
	_active = false

func _on_room_change(level_idx: int, room_idx: int) -> void:
	# if next room is this door's room, start activation timer for door
	var parent_room = get_parent()
	var valid = parent_room.is_valid()
	if valid and parent_room.get_level_idx() == level_idx and parent_room.get_room_idx() == room_idx:
		start_activation()

func start_activation() -> void:
	$ActivationTimer.start()

func _on_activation_timer_timeout() -> void:
	_active = true

func get_next_door_idx() -> int:
	return _next_door_idx

func unlock() -> void:
	$CollisionShape2D/ColorRect.color = Color(1.0, 1.0, 1.0, 1.0)
	_locked = false
	$Interactable.set_active(false)

func is_locked() -> bool:
	return _locked

func get_room_idx() -> int:
	return _room_idx

func _on_body_entered(body: Node2D) -> void:
	if body == RoomManager.get_player() and not _locked:
		next_room()
