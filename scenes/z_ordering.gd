extends Node

var _sprite: Sprite2D
var _marker: Marker2D

func init(sprite: Sprite2D) -> void:
	_sprite = sprite

func init_marker(sprite: Sprite2D, marker: Marker2D) -> void:
	_sprite = sprite
	_marker = marker

func _process(_delta: float) -> void:
	if _marker != null:
		_sprite.z_index = int(_sprite.global_position.y)
	elif _sprite != null:
		_sprite.z_index = int(_sprite.global_position.y)
