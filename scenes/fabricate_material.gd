extends Node

class_name FabricateMaterial

@export var _texture: Texture2D
@export var _name: String

func get_texture() -> Texture2D:
	return _texture

func get_material_name() -> String:
	return _name
