extends Node2D

class_name Item

static var _next_id = 1

var _id

@export var _item_name: String
@export var _item_info: String

@export var _item_texture: Texture2D
@export var _object_texture: Texture2D

func _ready() -> void:
	_id = _next_id
	_next_id += 1

func _process(_delta: float) -> void:
	pass

func get_item_texture() -> Texture2D:
	return _item_texture

func get_object_texture() -> Texture2D:
	return _object_texture

func get_item_name() -> String:
	return _item_name

func get_item_info() -> String:
	return _item_info

func get_id() -> int:
	return _id

func _on_body_entered(body: Node2D) -> void:
	if body == RoomManager.get_player():
		Inventory.add_item(self)
		hide()
		$CollisionShape2D.call_deferred("set_disabled", true)
		#$CollisionShape2D.disabled = true
