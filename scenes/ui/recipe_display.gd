extends Control

var _recipe_cells: Array[Node]
var _selected_recipe_idx: int = 0

var _known_recipe_count: int

@export var _recipe_cell_scene: PackedScene

func init() -> void:
	# _recipe_cells = %RecipeContainer.get_children()
	init_recipe_cells()
	select(_recipe_cells[_selected_recipe_idx] as RecipeCell)

func init_recipe_cells() -> void:
	var known_recipes = Fabricator.get_known_recipes()

	# initialize recipe cell names and textures
	for result_name in known_recipes:
		create_recipe_cell(result_name)
	
	_known_recipe_count = known_recipes.size()

func _process(_delta: float) -> void:
	# selected recipe changes when action pressed (scroll up/down)
	if Input.is_action_just_pressed("change_recipe_up"):
		var new_recipe_idx = (_known_recipe_count + _selected_recipe_idx + 1) % _known_recipe_count
		var new_recipe = _recipe_cells[new_recipe_idx] as RecipeCell
		if new_recipe.visible:
			select(new_recipe)
	
	if Input.is_action_just_pressed("change_recipe_down"):
		var new_recipe_idx = (_known_recipe_count + _selected_recipe_idx - 1) % _known_recipe_count
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

func create_recipe_cell(result_name: String) -> RecipeCell:
	var new_cell = _recipe_cell_scene.instantiate()
	%RecipeContainer.add_child(new_cell)
	
	new_cell.result_name = result_name
	new_cell.texture = Recipes.get_recipe_result_texture(result_name)
	new_cell.init_recipe(self)
	_recipe_cells.append(new_cell)
	
	return new_cell

func on_recipe_learned(result_name: String) -> void:
	create_recipe_cell(result_name)
	_known_recipe_count += 1

func get_recipe_cells() -> Array[Control]:
	var cells: Array[Control]
	for child in _recipe_cells:
		cells.append(child as Control)
	
	return cells
