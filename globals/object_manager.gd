extends Node

const OBJECT_DATA_FILE_PATH: String = "res://objects.json"

# contains object data, key is result name
var _object_data: Dictionary

func _init() -> void:
	load_object_data_from_file()

# load object data from file into _object_data dictionary
func load_object_data_from_file():
	var file = FileAccess.open(OBJECT_DATA_FILE_PATH, FileAccess.READ)
	var content = file.get_as_text()

	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		_object_data = json.data
	else:
		print("object_manager ~ JSON Parse Error: ", json.get_error_message(), " in ", json.dat, " at line ", json.get_error_line())

func get_object_data(object_name: String) -> Dictionary:
	if object_name not in _object_data.keys():
		print("object_manager ~ get_object_data(): can't get data for object ", object_name, " because it doesn't exist.")
		var empty: Dictionary
		return empty
	
	return _object_data[object_name]

func get_object_range(object_name: String) -> float:
	if object_name not in _object_data.keys():
		print("object_manager ~ get_object_range(): can't get range for object ", object_name, " because it doesn't exist.")
		return -1
	
	if "range" not in _object_data[object_name].keys():
		print("object_manager ~ get_object_range(): can't get range for object ", object_name, " because it doesn't have a range.")
		return -1
	
	return _object_data[object_name]["range"]