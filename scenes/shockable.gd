extends Node

class_name Shockable

signal shock(lightning: Lightning)

@export var _lightning_scene: PackedScene

var _body: Node2D

func _ready() -> void:
	_body = get_parent()

func emit_shock() -> Lightning:
	# create lightning, init, and add it to the body
	var lightning = _lightning_scene.instantiate()
	lightning.init(_body)
	_body.add_child(lightning)

	# if player is being shocked and hasn't learned Shock Bomb recipe, learn Shock Bomb Recipe (with short delay)
	# if on_player() and not Fabricator.knows_recipe("Shock Bomb"):
	# 	lightning.get_node("LightningState/LightningGo/TransitionTimer").timeout.connect(_on_lightning_transition)
	# elif _body is LaserTurret:
	# 	_body.shock()
	# 	lightning.get_node("LightningState/LightningGo/AliveTimer").timeout.connect(_body._on_shock_timer_timeout)
	
	shock.emit(lightning)

	return lightning

# func _on_lightning_transition() -> void:
# 	Fabricator.learn_recipe("Shock Bomb")

func on_player() -> bool:
	return _body is Player
