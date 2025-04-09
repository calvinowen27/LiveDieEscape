extends Area2D

class_name Door

var _room_idx = 0
@export var _door_idx = 0
# @export var _next_level_idx: int
# @export var _next_room_idx: int
# @export var _next_door_idx: int

@export var _locked = false
@export var _consume_key = false

var _player_touching: bool = false

var _active = false # if door can be used

func _init() -> void:
	EventBus.change_room.connect(_on_room_change)
	
func _ready() -> void:
	_room_idx = get_parent().get_room_idx()

	# initialize interactable node
	var interactable = $Interactable
	interactable.interact.connect(attempt_open)
	interactable.set_active(_locked)
	$Interactable/InteractLabel.rotation = -rotation
	
	if _locked:
		$Sprite2D.frame_coords.y = 1
		$RigidBody2D/CollisionShape2D.disabled = false
	
	if abs(rotation - (float(3)/2)*PI) <= 0.1:
		$Sprite2D.frame_coords.x = 1
	elif abs(rotation - PI/2) <= 0.1:
		$Sprite2D.frame_coords.x = 2

func attempt_open() -> void:
	if _active:
		# check for correct key in inventory
		var key_found = false
		var keys = Inventory.get_items_of_group("Keys")
		for key in keys:
			if key.unlocks_door(RoomManager.get_curr_level(), _room_idx, _door_idx):
				# unlock and next room
				key_found = true
				unlock()
				if _consume_key:
					Inventory.del_item(key)
				break
		
		if not key_found:
			$Interactable.set_active(true)

func next_room() -> void:
	# await get_tree().create_timer(1).timeout
	# await get_tree().process_frame
	RoomManager.door_entered(_door_idx)
	_active = false

func _on_room_change(level_idx: int, room_idx: int) -> void:
	# make sure door and room are valid and match, then activate
	var parent_room = get_parent()
	var valid = parent_room.is_valid()
	if valid and parent_room.get_level_idx() == level_idx and parent_room.get_room_idx() == room_idx:
		_active = true

func unlock() -> void:
	$Sprite2D.frame_coords.y = 0
	# $Sprite2D.texture = _unlocked_texture
	$RigidBody2D/CollisionShape2D.disabled = true
	_locked = false

	if _player_touching:
		next_room()

func is_locked() -> bool:
	return _locked

func get_room_idx() -> int:
	return _room_idx

func _on_body_entered(body: Node2D) -> void:
	if body == RoomManager.get_player():
		_player_touching = true

		if not _locked:
			next_room()

func _on_body_exited(body: Node2D) -> void:
	if body == RoomManager.get_player():
		_player_touching = false
