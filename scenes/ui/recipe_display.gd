extends Control

var _recipe_cells: Array
var _selected_recipe_idx: int = 0
var _recipe_count: int

func _ready() -> void:
	_recipe_cells = get_tree().get_nodes_in_group("Recipes")

	init_recipe_cells()
	
	select(_recipe_cells[_selected_recipe_idx] as RecipeCell)

func init_recipe_cells() -> void:
	var recipes = Recipes.get_recipes()

	# initialize recipe cell names and textures
	var idx = 0
	for result_name in recipes.keys():
		# print("init recipe ", result_name)

		var cell = _recipe_cells[idx]
		cell.result_name = result_name
		cell.texture = load(recipes[result_name]["result_texture"])
		cell.init_recipe(self)

		idx += 1
	
	# number of initialized recipes
	_recipe_count = idx
	
	# hide uninitialized cells
	for i in range(idx, _recipe_cells.size()):
		_recipe_cells[i].hide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("change_recipe_up"):
		var new_recipe_idx = (_selected_recipe_idx + 1) % _recipe_count
		var new_recipe = _recipe_cells[new_recipe_idx] as RecipeCell
		if new_recipe.visible:
			select(new_recipe)
	
	if Input.is_action_just_pressed("change_recipe_down"):
		var new_recipe_idx = (_selected_recipe_idx - 1) % _recipe_count
		var new_recipe = _recipe_cells[new_recipe_idx] as RecipeCell
		if new_recipe.visible:
			select(new_recipe)

# select recipe
func select(recipe: RecipeCell) -> void:
	# recipe not visible --> uninitialized
	if not recipe.visible:
		return
	
	# deselect old recipe and select new recipe
	_recipe_cells[_selected_recipe_idx].deselect()
	_selected_recipe_idx = _recipe_cells.find(recipe)
	recipe.select()

func get_recipe_cells() -> Array[Control]:
	var cells: Array[Control]
	for child in $GridContainer.get_children():
		cells.append(child as Control)
	
	return cells
