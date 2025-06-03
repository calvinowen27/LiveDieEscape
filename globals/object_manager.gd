extends Node

const OBJECT_DATA_FILE_PATH: String = "res://objects.json"

var _object_file: FileAccess
var _file_last_modified: int

# contains object data, key is result name
var _object_data: Dictionary

func _init() -> void:
	load_object_data_from_file()

# load object data from file into _object_data dictionary
func load_object_data_from_file():
	_object_file = FileAccess.open(OBJECT_DATA_FILE_PATH, FileAccess.READ)
	_file_last_modified = FileAccess.get_modified_time(OBJECT_DATA_FILE_PATH)
	if _file_last_modified == 0:
		print("object_manager ~ load_object_data_from_file(): failed to get file last modified time")

	var content = _object_file.get_as_text()

	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		_object_data = json.data
	else:
		print("object_manager ~ load_object_data_from_file(): JSON Parse Error- ", json.get_error_message(), " in ", json.dat, " at line ", json.get_error_line())

func get_object_data(object_name: String) -> Dictionary:
	# check if file modified since last check and reload if so
	var file_last_modified = FileAccess.get_modified_time(OBJECT_DATA_FILE_PATH)
	if file_last_modified != _file_last_modified:
		load_object_data_from_file()

	if object_name not in _object_data.keys():
		print("object_manager ~ get_object_data(): can't get data for object ", object_name, " because it doesn't exist.")
		var empty: Dictionary
		return empty
	
	return _object_data[object_name]

func get_object_range(object_name: String) -> float:
	var object_data = get_object_data(object_name)
	
	if "range" not in object_data.keys():
		print("object_manager ~ get_object_range(): can't get range for object ", object_name, " because it doesn't have a range.")
		return -1
	
	return object_data["range"]