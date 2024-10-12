extends Node2D

class_name Interactable

var _player_in_range = false
var _is_active = true

signal interact
signal interactable_set(val: bool)

func _process(_delta: float) -> void:
	# check for player interaction
	if Input.is_action_just_pressed("interact") and _player_in_range:
		interact.emit()

func _on_interact_area_body_entered(body: Node2D) -> void:
	if body == RoomManager.get_player() and _is_active:
		_set_interactable(true)

func _on_interact_area_body_exited(body: Node2D) -> void:
	if body == RoomManager.get_player():
		_set_interactable(false)

func _set_interactable(val: bool) -> void:
	_player_in_range = val
	$InteractLabel.visible = val
	interactable_set.emit(val)

func is_active() -> bool:
	return _is_active

func set_active(val: bool) -> void:
	_is_active = val
	
	if not val:
		$InteractLabel.visible = false
