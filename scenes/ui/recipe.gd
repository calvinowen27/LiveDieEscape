extends Control

class_name Recipe

@export var result_name: String
var selected: bool = false

func _ready() -> void:
	if result_name not in Fabricator.known_recipes:
		hide()
	
	init_recipe()

func _process(_delta: float) -> void:
	if RoomManager.get_curr_room() == null or not RoomManager.get_curr_room().is_valid():
		return
	
	if selected and Input.is_action_just_pressed("use_item"):
		try_create()

func init_recipe() -> void:
	if result_name not in Fabricator.recipes.keys():
		return
	
	var recipe: Dictionary = Fabricator.recipes[result_name]["recipe"]
	
	for key in recipe.keys():
		var material = load("res://scenes/ui/recipe_material.tscn").instantiate()
		$Panel/Materials.add_child(material)
		material.get_node("Quantity").text = "x %d" % recipe[key]
		# also set material texture here
	
	$Panel/ResultName.text = result_name

func try_create() -> bool:
	var mouse_pos = Vector2i(get_viewport().get_mouse_position())
	return Fabricator.create_object(result_name, mouse_pos - Vector2i((mouse_pos.x % 108), (mouse_pos.y % 108)) + Vector2i(54, 108))

func select() -> void:
	selected = true
	$Panel/Outline.show()

func deselect() -> void:
	selected = false
	$Panel/Outline.hide()

func _on_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		get_parent().select(self)
