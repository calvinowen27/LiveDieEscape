extends Node

var resources: Dictionary

var recipes: Dictionary

func _ready() -> void:
	load_recipes()
	
	add_resource("scrap", 5)

func _process(_delta: float) -> void:
	if RoomManager.get_curr_room() == null or not RoomManager.get_curr_room().is_valid():
		return
	
	if Input.is_action_just_pressed("use_item"):
		if not create_object("disruptor", RoomManager.get_player().position):
			print("failed to create disruptor with fabricator")

func load_recipes() -> void:
	var file = FileAccess.open("res://recipes.json", FileAccess.READ)
	var content = file.get_as_text()

	var json = JSON.new()
	var error = json.parse(content)
	if error != OK:
		print("fabricator ~ JSON Parse Error: ", json.get_error_message(), " in ", json.dat, " at line ", json.get_error_line())
	else:
		recipes = json.data

func add_resource(name: String, quantity: int) -> int:
	if resources.find_key(name) == null:
		resources[name] = quantity
		return quantity
	else:
		resources[name] += quantity
		return resources[name]

func create_object(name: String, location: Vector2) -> bool:
	if name not in recipes.keys():
		print("fabricator ~ create_object(): can't create object of name ", name, " because it doesn't exist")
		return false
	
	var recipe: Dictionary = recipes[name]["recipe"]

	for key in recipe.keys():
		if key not in resources.keys():
			print("fabricator ~ create_object(): resource ", key, " not present in resources dictionary")
			return false
		if recipe[key] > resources[key]:
			return false
	
	for key in recipe.keys():
		resources[key] -= recipe[key]
	
	RoomManager.spawn_object(recipes[name]["result"], location)
	
	print(resources)
	
	return true
