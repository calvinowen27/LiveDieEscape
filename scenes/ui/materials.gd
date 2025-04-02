extends GridContainer

var materials: Dictionary

func _ready() -> void:
	EventBus.materials_update.connect(_on_materials_update)
	var children = get_children()
	materials["rubble"] = children[0]
	materials["scrap"] = children[1]
	materials["antenna"] = children[2]
	materials["force_field_emitter"] = children[3]
	
	for key in materials.keys():
		var material = materials[key]
		material.show()
		material.get_node("Quantity").text = "x0"
		material.get_node("TextureRect").texture = load("res://resources/art/%s.png" % key)

func _on_materials_update() -> void:
	for key in materials.keys():
		var material = materials[key]
		material.get_node("Quantity").text = "x%d" % Fabricator.get_mat_count(key)
