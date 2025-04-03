extends Control

class_name Recipe

@export var result_name: String
@export var texture: Texture2D

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
	
	$Panel/Result.texture = texture
	$Panel/ResultName.text = result_name

	for key in recipe.keys():
		var material = load("res://scenes/ui/recipe_material.tscn").instantiate()
		$Panel/Materials.add_child(material)
		material.get_node("Quantity").text = "x%d" % recipe[key]
		material.get_node("TextureRect").texture = load("res://resources/art/%s.png" % key)
	
func try_create() -> bool:
	var mouse_pos = Vector2i(get_viewport().get_mouse_position())
	return Fabricator.create_object(result_name, mouse_pos)

func select() -> void:
	selected = true
	$Panel/Outline.show()

	var fab_temp_parent = get_tree().root.get_node("Main/FabricateTemplate")

	# if Fabricator.fab_temp != null:
	# 	fab_temp_parent.remove_child(Fabricator.fab_temp)
	
	for child in fab_temp_parent.get_children():
		fab_temp_parent.remove_child(child)
	
	fab_temp_parent.add_child(load("res://scenes/world_objects/fabricate_templates/%s_fabricate_template.tscn" % Fabricator.recipes[result_name]["object_name"]).instantiate())

	EventBus.recipe_select.emit(self as Recipe)

func deselect() -> void:
	selected = false
	$Panel/Outline.hide()

func _on_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		get_parent().select(self)
