extends Node

var _sprite: Sprite2D

func init(sprite: Sprite2D) -> void:
	_sprite = sprite

func _process(_delta: float) -> void:
	_sprite.z_index = int(_sprite.global_position.y)
