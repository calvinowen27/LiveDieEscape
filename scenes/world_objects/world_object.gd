extends RigidBody2D

class_name WorldObject

@export var _object_name: String

var _data: Dictionary

func _ready() -> void:
	_data = ObjectManager.get_object_data(_object_name)

func die() -> void:
	self.queue_free()

func get_object_name() -> String:
	return _object_name

func get_data() -> Dictionary:
	return _data
