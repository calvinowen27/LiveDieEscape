extends Node2D

class_name Interactable

var _player_in_range = false
var _is_active = true

signal interact

func _ready() -> void:
	$InteractLabel.rotation = rotation + (PI / 2)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and _player_in_range:
		interact.emit()

func _on_interact_area_body_entered(body: Node2D) -> void:
	if body == RoomManager.get_player() and _is_active:
		_player_in_range = true
		$InteractLabel.visible = true

func _on_interact_area_body_exited(body: Node2D) -> void:
	if body == RoomManager.get_player():
		_player_in_range = false
		$InteractLabel.visible = false

func is_active() -> bool:
	return _is_active

func set_active(val: bool) -> void:
	_is_active = val
	
	if not val:
		$InteractLabel.visible = false
