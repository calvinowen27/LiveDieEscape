extends Area2D

var _triggered: bool = false
@onready var _sprite: Sprite2D = $Sprite2D

func _on_body_entered(body: Node2D) -> void:
	# one time trigger
	if _triggered: return
	
	# only shock player or laser turrets (can change later)
	if body == RoomManager.get_player() or body is LaserTurret:
		_trigger_on_body(body)

func _trigger_on_body(body: Node2D) -> void:
	# check if body can be shocked
	if not body.has_node("Shockable"): return

	# shock the body
	body.get_node("Shockable").shock()

	_triggered = true
	_sprite.frame_coords.x = 1 # switch to disabled sprite

	# might not be the best place for this
	if body is LaserTurret:
		body.shock()
	
	# enable salvage
	$Salvageable.set_active(true)

func _on_salvage_interactable_interact() -> void:
	# TODO: this stuff should be stored in a file
	Fabricator.add_material("scrap", 2)
	Fabricator.add_material("rubble", 1)
	Fabricator.add_material("capacitor", 1)
