extends Node

var _materials: Dictionary

var _known_recipes: Array[String] = ["Wall", "Disruptor"]

var fab_range: int = 64 # idk this can change

var active: bool = false

var _curr_recipe: RecipeCell
var _snap_temp: bool = true
var mouse_in_range: bool = false

var fab_temp: FabricateTemplate

var ui_recipes: Array

func _ready() -> void:
	EventBus.player_death.connect(_on_player_death)
	EventBus.recipe_select.connect(_on_recipe_select)
	
	EventBus.start_game.connect(_on_game_start)

func _process(_delta: float) -> void:
	if fab_temp == null:
		return

	# show or hide fabricate template
	if Input.is_action_just_pressed("fabricate"):
		active = not active # keep track of whether we can fabricate or not with left click
		if active:
			fab_temp.show()
		else:
			fab_temp.hide()
	
	# move fabricate template with grid snapping if necessary (if active)
	if active and Game.is_game_running():
		var mouse_pos = Vector2i(Game.get_camera().get_local_mouse_position() + Game.get_camera().position)
		if (Vector2(mouse_pos) - RoomManager.get_player().position).length() > fab_range:
			if mouse_in_range:
				mouse_in_range = false
				fab_temp.update()
		else:
			if not mouse_in_range:
				mouse_in_range = true
				fab_temp.update()
		
		if _snap_temp:
			fab_temp.get_parent().position = mouse_pos - Vector2i((mouse_pos.x % 16), (mouse_pos.y % 16))
		else:
			fab_temp.get_parent().position = mouse_pos

# add quantity of material to _materials Dictionary
func add_material(mat_name: String, quantity: int) -> int:
	if mat_name not in _materials.keys():
		_materials[mat_name] = quantity
	else:
		_materials[mat_name] += quantity
	
	EventBus.materials_update.emit()

	fab_temp.update()

	Game.get_fabricate_material_manager().spawn_material_get(mat_name, quantity)

	return _materials[mat_name]

func set_materials(new_materials: Dictionary) -> void:
	_materials = new_materials.duplicate()

	EventBus.materials_update.emit()

func try_create_object(result_name: String, location: Vector2) -> bool:
	# snap to grid if necessary
	if Recipes.get_recipe_snap_to_grid(result_name):
		location -= Vector2(Vector2i((int(location.x) % 16), (int(location.y) % 16)) - Vector2i(8, 16))

	# check if crafting is valid
	if not active or not fab_temp.valid or not mouse_in_range:
		return false
	
	if not Recipes.recipe_exists(result_name):
		print("fabricator ~ try_create_object(): can't create object of name ", result_name, " because it doesn't exist")
		return false

	# make sure enough of all _materials for recipe and update material counts
	if not Recipes.can_craft_recipe(result_name, _materials, true):
		return false
	
	# spawn resulting object
	var obj_name = Recipes.get_recipe_object_name(result_name)
	if obj_name == "":
		return false
	
	RoomManager.spawn_object(obj_name, location)
	
	EventBus.materials_update.emit()

	# update fabricate template color if necessary
	fab_temp.update()
	
	return true

func can_craft() -> bool:
	if not mouse_in_range:
		return false
	
	return Recipes.can_craft_recipe(_curr_recipe.result_name, _materials)

func _on_player_death() -> void:
	_materials.clear()
	EventBus.materials_update.emit()
	fab_temp.update()
	# may need to update this to save material count at start of level

func _on_game_start() -> void:
	# select first recipe at start
	ui_recipes = Game.get_HUD().get_recipe_display().get_recipe_cells()
	_curr_recipe = ui_recipes[0] as RecipeCell

# return quantity of material or 0 if none
func get_mat_count(mat_name: String) -> int:
	if mat_name not in _materials.keys():
		return 0
	
	return _materials[mat_name]

# add recipe name to known _recipes if not already learned
func learn_recipe(result_name: String) -> void:
	if result_name in _known_recipes: return
	
	_known_recipes.append(result_name)

	for recipe in ui_recipes:
		if recipe.result_name == result_name:
			recipe.show()
	
	Game.get_HUD().get_recipe_display().on_recipe_learned(result_name)

func knows_recipe(result_name: String) -> bool:
	return result_name in _known_recipes

func get_known_recipes() -> Array[String]:
	return _known_recipes

func _on_recipe_select(recipe: RecipeCell) -> void:
	# set curr recipe and whether fabricate template snaps to grid
	_curr_recipe = recipe
	_snap_temp = Recipes.get_recipe_snap_to_grid(recipe.result_name)
	if fab_temp != null:
		fab_temp.queue_free()
	
	# TODO: fix this
	fab_temp = get_tree().root.get_node("Main/FabricateTemplate").get_child(0) as FabricateTemplate

	fab_temp.visible = active

func get_curr_recipe() -> RecipeCell:
	return _curr_recipe

func clear_materials() -> void:
	_materials.clear()

func get_materials_copy() -> Dictionary:
	return _materials.duplicate()
