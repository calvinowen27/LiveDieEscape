extends Area2D

class_name FabricateTemplate

var valid: bool = true

var invalid_objs: Array

func _ready() -> void:
	EventBus.recipe_select.connect(_on_recipe_select)

	# Fabricator.set_fab_temp(self)

func update() -> void:
	print("update")
	if Fabricator.can_craft() and valid:
		print("can craft")
		$Sprite2D/Square.color = Color(0x2785ff97)
	else:
		print("can not craft")
		$Sprite2D/Square.color = Color(0xe0000097)

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		valid = false
		invalid_objs.append(body)
		print("invalid")
		update()

func _on_body_exited(body: Node2D) -> void:
	if body in invalid_objs:
		invalid_objs.erase(body)
		if invalid_objs.size() == 0:
			valid = true
			print("valid")
			update()

func _on_recipe_select(_recipe: Recipe) -> void:
	# $Sprite2D.texture = recipe.texture

	update()
