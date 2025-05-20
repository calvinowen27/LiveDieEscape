extends Node

var _hud: Control

func _ready() -> void:
	_hud = %HUD

func get_HUD() -> Control:
	return _hud

func get_camera() -> Camera2D:
	return RoomManager.get_curr_room().get_node("%Camera") as Camera2D
