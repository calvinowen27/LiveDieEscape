extends Node

var _recipes: Dictionary

func _ready() -> void:
	load_recipes_from_file()

func load_recipes_from_file():
	var file = FileAccess.open("res://recipes.json", FileAccess.READ)
	var content = file.get_as_text()

	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		_recipes = json.data
	else:
		print("level_manager ~ JSON Parse Error: ", json.get_error_message(), " in ", json.dat, " at line ", json.get_error_line())

func get_recipes() -> Dictionary:
	return _recipes

func get_recipe(result_name: String) -> Dictionary:
	if result_name not in _recipes.keys():
		print("recipes ~ get_recipe(): can't get recipe for ", result_name, " because it doesn't exist.")
		var empty: Dictionary # is this even allowed
		return empty
	
	return _recipes[result_name]

