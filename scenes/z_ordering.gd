extends Node

var _animated_sprite: AnimatedSprite2D

func init(animated_sprite: AnimatedSprite2D) -> void:
	_animated_sprite = animated_sprite

func _process(delta: float) -> void:
	_animated_sprite.z_index = _animated_sprite.global_position.y
