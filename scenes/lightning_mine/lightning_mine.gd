extends Area2D

var _triggered: bool = false
@onready var _sprite: Sprite2D = $Sprite2D

func _on_body_entered(body: Node2D) -> void:
	if _triggered: return
	
	if body == RoomManager.get_player() or body is LaserTurret:
		_trigger_on_body(body)

func _trigger_on_body(body: Node2D) -> void:
	body.add_child(load("res://scenes/lightning_mine/lightning.tscn").instantiate())
	_triggered = true
	_sprite.frame_coords.x = 1 # switch to disabled sprite

func _on_salvage_interactable_interact() -> void:
	Fabricator.add_material("scrap", 2)
	Fabricator.add_material("rubble", 1)
