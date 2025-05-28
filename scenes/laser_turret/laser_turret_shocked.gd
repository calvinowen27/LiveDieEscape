extends LaserTurretState

var _done: bool = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func update(_delta: float) -> String:
	# once shock timer is over, switch back to activated state
	if _done:
		return "LaserTurretActivated"
	
	return name

func laser_turret_state_enable(turret: LaserTurret, animation_player: AnimationPlayer, laser_sprite: Sprite2D, laser_raycast: RayCast2D) -> void:
	super.laser_turret_state_enable(turret, animation_player, laser_sprite, laser_raycast)
	
	_turret.set_ID_accessible(true)
	_turret.set_force_field_penetrable(true)

	laser_sprite.visible = false
	laser_raycast.enabled = false
	
	_laser_raycast.get_node("Spark").visible = false
	_laser_raycast.get_node("SparkEnd").visible = false

	# TODO: i still don't like this
	var lightning = _turret.get_node("Shockable").shock()
	# especially this:
	lightning.get_node("LightningState/LightningBuzz/AliveTimer").timeout.connect(_on_shock_timer_timeout)

# once shock timer is over, switch back to activated state
func _on_shock_timer_timeout() -> void:
	_done = true
