extends Node

class_name FabricateMaterialManager

var _fabricate_materials: Array[FabricateMaterial]

@export var _material_get_scene: PackedScene

@export var _material_get_spawn_offset: Vector2

var _mat_get_queue: Array

@export var _time_between_mat_get: float = 0.25
var _time_since_last_mat_get: float = 0

func _ready() -> void:
	for child in get_children():
		if child is FabricateMaterial:
			_fabricate_materials.append(child as FabricateMaterial)

func _process(delta):
	if _mat_get_queue.size() == 0: return

	_time_since_last_mat_get += delta

	if _time_since_last_mat_get > _time_between_mat_get:
		_time_since_last_mat_get = 0
		_mat_get_queue[0].start()
		_mat_get_queue.remove_at(0)

# spawn a material get particle from name
func spawn_material_get(mat_name: String, quantity: int) -> void:
	var fab_mat = get_fabricate_material(mat_name)
	if fab_mat == null: return
	
	var mat_get = _material_get_scene.instantiate()
	RoomManager.get_curr_room().add_child(mat_get)

	var pos_offset = Vector2(randf() * _material_get_spawn_offset.x - _material_get_spawn_offset.x / 2, _material_get_spawn_offset.y)
	
	mat_get.init(fab_mat, quantity, RoomManager.get_player().position + pos_offset)

	if _mat_get_queue.size() == 0: _time_since_last_mat_get = _time_between_mat_get
	_mat_get_queue.append(mat_get)

# get fabricate material by name
func get_fabricate_material(mat_name: String) -> FabricateMaterial:
	for mat in _fabricate_materials:
		if mat.get_material_name() == mat_name:
			return mat
	
	print("fabricate_materials(): material %s doesn't exist" % mat_name)
	return null

func get_fabricate_materials() -> Array[FabricateMaterial]:
	return _fabricate_materials
