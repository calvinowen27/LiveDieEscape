extends Area2D

var valid: bool = true

var invalid_objs: Array

func _ready() -> void:
	EventBus.recipe_select.connect(_on_recipe_select)

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		valid = false
		invalid_objs.append(body)


func _on_body_exited(body: Node2D) -> void:
	if body in invalid_objs:
		invalid_objs.erase(body)
		if invalid_objs.size() == 0:
			valid = true

func _on_recipe_select(recipe: Recipe) -> void:
	$Sprite2D.texture = recipe.texture
	
