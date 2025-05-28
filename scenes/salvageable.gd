extends Node2D

@export var _materials: Dictionary

@export var _base_area_collider: CollisionShape2D
@export var _expand_interact_area: bool = true
@export var _interact_area_scale: Vector2 = Vector2(1.5, 1.5)

func _ready() -> void:
	# duplicate base area collider and set proper scale and position to match shape
	var col_shape = $Interactable/InteractArea/CollisionShape2D
	col_shape.shape = _base_area_collider.shape.duplicate()
	col_shape.global_scale = _base_area_collider.global_scale
	col_shape.global_position = _base_area_collider.global_position

	# scale collision shape if desired
	if _expand_interact_area:
		col_shape.scale *= _interact_area_scale
	
	# make sure interactable is not accessible
	set_active(false)

func _on_interactable_interact() -> void:
	set_active(false)

	# add materials to fabricator
	for key in _materials.keys():
		Fabricator.add_material(key, _materials[key])

func set_active(val: bool) -> void:
	$Interactable.set_active(val)
