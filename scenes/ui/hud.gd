extends Control

class_name HUD

@onready var _material_display: Control = %MaterialDisplay

func _process(_delta: float) -> void:
	update()

func init() -> void:
	_material_display.init()

# update all nodes in HUD
func update() -> void:
	update_dash_bar()

func update_dash_bar() -> void:
	var dash_timer = RoomManager.get_player().get_node("PlayerState/DashCooldownTimer")
	var dash_bar = $DashProgressBar
	dash_bar.value = dash_bar.max_value - int(dash_timer.time_left / dash_timer.wait_time * dash_bar.max_value)

func get_recipe_display() -> Control:
	return %RecipeDisplay
