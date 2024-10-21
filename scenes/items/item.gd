extends Node2D

class_name Item

static var _next_id = 1

var _id

@export var _item_name: String
var _item_info: String

@export var _item_texture: Texture2D
@export var _object_texture: Texture2D

func _ready() -> void:
	$ZOrdering.init($Sprite2D)
	
	_id = _next_id
	_next_id += 1

func _process(_delta: float) -> void:
	pass

func pickup() -> void:
	$ItemState._set_curr_state("ItemInventory")

func drop() -> void:
	$ItemState._set_curr_state("ItemGround")

	position = RoomManager.get_player().global_position + Vector2(0, 60)

func use() -> void:
	#$ItemState._set_curr_state("ItemPlaced")
	print("using item %s" % _item_name)

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
