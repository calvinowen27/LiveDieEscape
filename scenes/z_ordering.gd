extends Node

var _sprite: Sprite2D

func init(sprite: Sprite2D) -> void:
	_sprite = sprite

func _process(delta: float) -> void:
	_sprite.z_index = _sprite.global_position.y
