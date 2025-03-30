extends Control

var recipes: Array
var recipe_idx: int = 0

func _ready() -> void:
	recipes = get_tree().get_nodes_in_group("Recipes")
	
	(recipes[recipe_idx] as Recipe).select()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("change_recipe_up"):
		var new_recipe_idx = (recipe_idx + 1) % 6
		var new_recipe = recipes[new_recipe_idx] as Recipe
		if new_recipe.visible:
			(recipes[recipe_idx] as Recipe).deselect()
			recipe_idx = new_recipe_idx
			new_recipe.select()
	
	if Input.is_action_just_pressed("change_recipe_down"):
		var new_recipe_idx = (recipe_idx - 1) % 6
		var new_recipe = recipes[new_recipe_idx] as Recipe
		if new_recipe.visible:
			(recipes[recipe_idx] as Recipe).deselect()
			recipe_idx = new_recipe_idx
			new_recipe.select()

func select(recipe: Recipe) -> void:
	if not recipe.visible:
		return
	
	recipes[recipe_idx].deselect()
	recipe_idx = recipes.find(recipe)
	recipe.select()
