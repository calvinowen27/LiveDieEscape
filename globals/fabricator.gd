extends Node

var materials: Dictionary

var recipes: Dictionary

var known_recipes: Array = ["Wall", "Disruptor"]

var fab_range: int = 200 # idk this can change

var active: bool = false

var _curr_recipe: RecipeCell
var snap_temp: bool = true
var mouse_in_range: bool = false

var fab_temp: FabricateTemplate

var ui_recipes: Array

func _ready() -> void:
	EventBus.player_death.connect(_on_player_death)
	EventBus.recipe_select.connect(_on_recipe_select)
	
	EventBus.start_game.connect(_on_game_start)

	load_recipes()

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
		# print("active and game running")
		var mouse_pos = Vector2i(get_viewport().get_mouse_position())
		if (Vector2(mouse_pos) - RoomManager.get_player().position).length() > fab_range:
			if mouse_in_range:
				mouse_in_range = false
				fab_temp.update()
				print("out of range")
		else:
			if not mouse_in_range:
				mouse_in_range = true
				fab_temp.update()
				print("in range")
		
		if snap_temp:
			fab_temp.get_parent().position = mouse_pos - Vector2i((mouse_pos.x % 108), (mouse_pos.y % 108))
		else:
			fab_temp.get_parent().position = mouse_pos

# open file and create recipe dictionary
func load_recipes() -> void:
	var file = FileAccess.open("res://recipes.json", FileAccess.READ)
	var content = file.get_as_text()

	var json = JSON.new()
	var error = json.parse(content)
	if error != OK:
		print("fabricator ~ JSON Parse Error: ", json.get_error_message(), " in ", json.dat, " at line ", json.get_error_line())
	else:
		recipes = json.data

# add quantity of material to materials Dictionary
func add_material(mat_name: String, quantity: int) -> int:
	if mat_name not in materials.keys():
		materials[mat_name] = quantity
	else:
		materials[mat_name] += quantity
	
	EventBus.materials_update.emit()

	fab_temp.update()

	return materials[mat_name]

func create_object(result_name: String, location: Vector2) -> bool:
	
	# mouse_pos - Vector2i((mouse_pos.x % 108), (mouse_pos.y % 108)) + Vector2i(54, 108)

	# snap to grid if necessary
	if recipes[result_name]["snap-to-grid"]:
		location -= Vector2(Vector2i((int(location.x) % 108), (int(location.y) % 108)) - Vector2i(54, 108))

	# check if crafting is valid
	if not active or not fab_temp.valid or not mouse_in_range:
		return false
	
	if result_name not in recipes.keys():
		print("fabricator ~ create_object(): can't create object of name ", result_name, " because it doesn't exist")
		return false
	
	var recipe: Dictionary = recipes[result_name]["recipe"]

	# make sure enough of all materials for recipe
	for key in recipe.keys():
		if key not in materials.keys():
			print("fabricator ~ create_object(): resource ", key, " not present in materials dictionary")
			return false
		if recipe[key] > materials[key]:
			return false
	
	# update material counts
	for key in recipe.keys():
		materials[key] -= recipe[key]
	
	# spawn resulting object
	RoomManager.spawn_object(recipes[result_name]["object_name"], location)
	
	EventBus.materials_update.emit()

	# update fabricate template color if necessary
	fab_temp.update()
	
	return true

func can_craft() -> bool:
	if not mouse_in_range:
		return false
	
	var recipe = recipes[_curr_recipe.result_name]["recipe"] 
	for key in recipe.keys():
		if get_mat_count(key) < recipe[key]:
			return false
	
	return true

func _on_player_death() -> void:
	materials.clear()
	EventBus.materials_update.emit()
	fab_temp.update()
	# may need to update this to save material count at start of level

func _on_game_start() -> void:
	# set fabricate template and recipes ui elements
	# fab_temp = get_tree().root.get_node("Main/FabricateTemplate")
	# ui_recipes = get_tree().root.get_node("Main/HUDRect/HUD/Recipes/GridContainer").get_children()
	ui_recipes = Game.get_HUD().get_recipe_display().get_recipe_cells()

	_curr_recipe = ui_recipes[0] as RecipeCell

# return quantity of material or 0 if none
func get_mat_count(mat_name: String) -> int:
	if mat_name not in materials.keys():
		return 0
	
	return materials[mat_name]

# add recipe name to known recipes if not already learned
func learn_recipe(reuslt_name: String) -> void:
	known_recipes.append(reuslt_name)

	for recipe in ui_recipes:
		print(recipe.result_name)
		if recipe.result_name == reuslt_name:
			recipe.show()

func _on_recipe_select(recipe: RecipeCell) -> void:
	# set curr recipe and whether fabricate template snaps to grid
	_curr_recipe = recipe
	snap_temp = recipes[recipe.result_name]["snap-to-grid"]
	if fab_temp != null:
		fab_temp.queue_free()
	
	fab_temp = get_tree().root.get_node("Main/FabricateTemplate").get_child(0) as FabricateTemplate

	fab_temp.visible = active

func get_curr_recipe() -> RecipeCell:
	return _curr_recipe
