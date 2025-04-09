extends LaserTurretState

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func update(_delta: float) -> String:
	# unredeemable
	return name

func laser_turret_state_enable(turret: LaserTurret, animation_player: AnimationPlayer, laser_sprite: Sprite2D, laser_raycast: RayCast2D) -> void:
	super.laser_turret_state_enable(turret, animation_player, laser_sprite, laser_raycast)
	
	_turret.get_node("Sprite2D/Spark").visible = false

	_turret.get_node("ScrapInteractable").set_active(true)
	_turret.get_node("ForceFieldInteractable").set_active(false)
	
	if _turret.has_node("ForceFieldWorld"):
	#var ff_world_child = _turret.get_node("ForceFieldWorld")
	#if ff_world_child != null:
		_turret.remove_child.bind(_turret.get_node("ForceFieldWorld")).call_deferred()

	animation_player.play("laser_turret_broken")
