extends Control

class_name RecipeCell

const FABRICATE_TEMPLATE_PATH: String = "res://scenes/world_objects/fabricate_templates/%s_fabricate_template.tscn"

@export var result_name: String
@export var texture: Texture2D

@export var _recipe_material_scene: PackedScene

var selected: bool = false

var _recipe_manager: Control

func init_recipe(recipe_manager: Control) -> void:
	_recipe_manager = recipe_manager

	if result_name not in Recipes.get_recipes().keys():
		return
	
	var recipe: Dictionary = Recipes.get_recipe(result_name)
	
	$Panel/Result.texture = texture
	$Panel/ResultName.text = result_name

	for key in recipe.keys():
		var recipe_material = _recipe_material_scene.instantiate()
		$Panel/Materials.add_child(recipe_material)
		recipe_material.get_node("Quantity").text = "x%d" % recipe[key]
		recipe_material.get_node("TextureRect").texture = Game.get_fabricate_material_manager().get_fabricate_material_texture(key)

func _process(_delta: float) -> void:
	if RoomManager.get_curr_room() == null or not RoomManager.get_curr_room().is_valid():
		return
	
	if selected and Input.is_action_just_pressed("use_item"):
		try_create()

func try_create() -> bool:
	var mouse_pos = Vector2i(Game.get_camera().get_local_mouse_position() + Game.get_camera().position)
	return Fabricator.try_create_object(result_name, mouse_pos)

func select() -> void:
	selected = true
	$Panel/Outline.show()

	var fab_temp_parent = get_tree().root.get_node("Main/FabricateTemplate")

	# if Fabricator.fab_temp != null:
	# 	fab_temp_parent.remove_child(Fabricator.fab_temp)
	
	for child in fab_temp_parent.get_children():
		fab_temp_parent.remove_child(child)
	
	fab_temp_parent.add_child(load(FABRICATE_TEMPLATE_PATH % Recipes.get_recipe_object_name(result_name)).instantiate())

	EventBus.recipe_select.emit(self as RecipeCell)

func deselect() -> void:
	selected = false
	$Panel/Outline.hide()

func _on_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_recipe_manager.select(self)
