extends Area2D

class_name FabricateTemplate

var valid: bool = true

var invalid_objs: Array

var _range: float = 0

@export var _object_name: String

func _ready() -> void:
	EventBus.recipe_select.connect(_on_recipe_select)

func update() -> void:
	# TODO: clean all this up
	# print("update")
	if Fabricator.can_craft() and valid:
		# print("can craft")
		$Sprite2D/Square.color = Color(0x2785ff97)
	else:
		# print("can not craft")
		$Sprite2D/Square.color = Color(0xe0000097)
	
	set_range(ObjectManager.get_object_range(_object_name))

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		valid = false
		invalid_objs.append(body)
		# print("invalid")
		update()

func _on_body_exited(body: Node2D) -> void:
	if body in invalid_objs:
		invalid_objs.erase(body)
		if invalid_objs.size() == 0:
			valid = true
			# print("valid")
			update()

func _on_recipe_select(_recipe: RecipeCell) -> void:
	# $Sprite2D.texture = recipe.texture

	update()

func set_range(range_: float) -> void:
	_range = range_

	if _range < 0: return


	$Range.scale.x = _range * 2 / $Range.texture.get_width()
	$Range.scale.y = _range * 2 / $Range.texture.get_width()
	$Range.visible = true
