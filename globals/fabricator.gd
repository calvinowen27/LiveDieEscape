extends Node

var materials: Dictionary

var recipes: Dictionary

var known_recipes: Array = ["Wall", "Disruptor"]

var fab_range: int = 200 # idk this can change

var active: bool = false

var snap_temp: bool = true

func _ready() -> void:
	EventBus.player_death.connect(_on_player_death)
	EventBus.recipe_select.connect(_on_recipe_select)
	
	load_recipes()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("fabricate"):
		active = not active
		if active:
			get_tree().root.get_node("Main/FabricateTemplate").show()
		else:
			get_tree().root.get_node("Main/FabricateTemplate").hide()
	
	if active and Game.is_game_running():
		var fab_temp = get_tree().root.get_node("Main/FabricateTemplate")
		var mouse_pos = Vector2i(get_viewport().get_mouse_position())
		if snap_temp:
			fab_temp.position = mouse_pos - Vector2i((mouse_pos.x % 108), (mouse_pos.y % 108))
		else:
			fab_temp.position = mouse_pos - Vector2i(54, 108)

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

func add_material(mat_name: String, quantity: int) -> int:
	if mat_name not in materials.keys():
		materials[mat_name] = quantity
	else:
		materials[mat_name] += quantity
	
	EventBus.materials_update.emit()
	return materials[mat_name]

func create_object(result_name: String, location: Vector2) -> bool:
	
	# mouse_pos - Vector2i((mouse_pos.x % 108), (mouse_pos.y % 108)) + Vector2i(54, 108)

	if recipes[result_name]["snap-to-grid"]:
		location -= Vector2(Vector2i((int(location.x) % 108), (int(location.y) % 108)) - Vector2i(54, 108))

	if not active or not get_tree().root.get_node("Main/FabricateTemplate").valid or (location - RoomManager.get_player().position).length() > fab_range:
		return false
	
	if result_name not in recipes.keys():
		print("fabricator ~ create_object(): can't create object of name ", result_name, " because it doesn't exist")
		return false
	
	var recipe: Dictionary = recipes[result_name]["recipe"]

	for key in recipe.keys():
		if key not in materials.keys():
			print("fabricator ~ create_object(): resource ", key, " not present in materials dictionary")
			return false
		if recipe[key] > materials[key]:
			return false
	
	for key in recipe.keys():
		materials[key] -= recipe[key]
	
	RoomManager.spawn_object(recipes[result_name]["object_name"], location)
	
	print(materials)
	
	EventBus.materials_update.emit()
	
	return true

func _on_player_death() -> void:
	materials.clear()
	EventBus.materials_update.emit()
	# may need to update this to save material count at start of level

func get_mat_count(mat_name: String) -> int:
	if mat_name not in materials.keys():
		return 0
	
	return materials[mat_name]

func learn_recipe(recipe_name: String) -> void:
	known_recipes.append(recipe_name)

	var ui_recipes = get_tree().root.get_node("Main/HUDRect/HUD/Recipes/GridContainer").get_children()
	for recipe in ui_recipes:
		print(recipe.result_name)
		if recipe.result_name == recipe_name:
			recipe.show()

func _on_recipe_select(recipe: Recipe) -> void:
	snap_temp = recipes[recipe.result_name]["snap-to-grid"]
