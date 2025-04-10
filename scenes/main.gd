extends Node

var _hud: Control

func _ready() -> void:
	_hud = %HUD

func get_HUD() -> Control:
	return _hud
