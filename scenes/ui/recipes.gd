extends Control


func _ready() -> void:
	var recipes = get_tree().get_nodes_in_group("Recipes")
	
	(recipes[0] as Recipe).selected = true
