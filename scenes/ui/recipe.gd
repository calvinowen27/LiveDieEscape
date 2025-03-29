extends Control

class_name Recipe

@export var result_name: String
var selected: bool = false

func _ready() -> void:
	if result_name not in Fabricator.known_recipes:
		hide()

func _process(_delta: float) -> void:
	if RoomManager.get_curr_room() == null or not RoomManager.get_curr_room().is_valid():
		return
	
	if selected and Input.is_action_just_pressed("use_item"):
		try_create()

func try_create() -> bool:
	var mouse_pos = Vector2i(get_viewport().get_mouse_position())
	return Fabricator.create_object(result_name, mouse_pos - Vector2i((mouse_pos.x % 108), (mouse_pos.y % 108)) + Vector2i(54, 108))
