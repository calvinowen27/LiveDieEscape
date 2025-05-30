extends Node

const RECIPES_FILE_PATH: String = "res://recipes.json"

# contains recipe info, key is result name
var _recipes: Dictionary

func _ready() -> void:
	load_recipes_from_file()

# load recipes from file into _recipes dictionary
func load_recipes_from_file():
	var file = FileAccess.open(RECIPES_FILE_PATH, FileAccess.READ)
	var content = file.get_as_text()

	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		_recipes = json.data
	else:
		print("level_manager ~ JSON Parse Error: ", json.get_error_message(), " in ", json.dat, " at line ", json.get_error_line())

func get_recipes() -> Dictionary:
	return _recipes

# check if recipe exists in _recipes
func recipe_exists(result_name: String) -> bool:
	return result_name in _recipes.keys()

# get the recipe with result_name
func get_recipe(result_name: String) -> Dictionary:
	if result_name not in _recipes.keys():
		print("recipes ~ get_recipe(): can't get recipe for ", result_name, " because it doesn't exist.")
		var empty: Dictionary # is this even allowed
		return empty
	
	return _recipes[result_name]["recipe"]

# check if recipe with result_name snaps to grid or not
func get_recipe_snap_to_grid(result_name: String) -> bool:
	if result_name not in _recipes.keys():
		print("recipes ~ get_recipe_snap_to_grid(): can't get snap to grid for ", result_name, " because it doesn't exist.")
		return false
	
	return _recipes[result_name]["snap-to-grid"]

# get the result object name of recipe with result_name
func get_recipe_object_name(result_name: String) -> String:
	if result_name not in _recipes.keys():
		print("recipes ~ get_recipe_object_name(): can't get object name for ", result_name, " because it doesn't exist.")
		return ""
	
	return _recipes[result_name]["object-name"]

# get texture of result of recipe with result_name
func get_recipe_result_texture(result_name: String) -> Texture2D:
	if result_name not in _recipes.keys():
		print("recipes ~ get_recipe_result_texture(): can't get texture for ", result_name, " because it doesn't exist.")
		return null
	
	return load(_recipes[result_name]["result-texture"])

# check if recipe can be crafted with the materials passed
# if update_materials is true, the materials needed will be subtracted from the materials passed
func can_craft_recipe(result_name: String, materials: Dictionary, update_materials: bool = false) -> bool:
	var recipe = get_recipe(result_name)
	for key in recipe.keys():
		if key not in materials.keys():
			# print("recipes ~ can_craft_recipe(): resource ", key, " not present in materials dictionary")
			return false
		if recipe[key] > materials[key]:
			return false
	
	if update_materials:
		for key in recipe.keys():
			materials[key] -= recipe[key]
	
	return true
