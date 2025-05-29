extends GridContainer

var materials: Dictionary

func _ready() -> void:
	EventBus.materials_update.connect(_on_materials_update)

func init() -> void:
	var fabricate_material_manager = Game.get_fabricate_material_manager()

	var children = get_children()
	var i = 0

	# initialize each material display from fabricate material manager
	for mat in fabricate_material_manager.get_fabricate_materials():
		var mat_display = children[i]
		materials[mat.get_material_name()] = mat_display
		i += 1

		mat_display.show()
		mat_display.get_node("Quantity").text = "x0"
		mat_display.get_node("TextureRect").texture = fabricate_material_manager.get_fabricate_material(mat.get_material_name()).get_texture()

func _on_materials_update() -> void:
	for key in materials.keys():
		var mat = materials[key]
		mat.get_node("Quantity").text = "x%d" % Fabricator.get_mat_count(key)
