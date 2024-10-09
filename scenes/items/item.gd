extends Node2D

class_name Item

@export var _item_texture: Texture2D
@export var _object_texture: Texture2D

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func pickup() -> void:
	$ItemState._set_curr_state("ItemInventory")

func drop() -> void:
	$ItemState._set_curr_state("ItemGround")

	position = RoomManager.get_player().global_position + Vector2(0, 20)

func use() -> void:
	$ItemState._set_curr_state("ItemPlaced")

func get_item_texture() -> Texture2D:
	return _item_texture

func get_object_texture() -> Texture2D:
	return _object_texture
