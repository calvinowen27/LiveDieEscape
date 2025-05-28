extends LaserTurretState

var _done: bool = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func update(_delta: float) -> String:
	if _done:
		return "LaserTurretActivated"
    
	return name

func laser_turret_state_enable(turret: LaserTurret, animation_player: AnimationPlayer, laser_sprite: Sprite2D, laser_raycast: RayCast2D) -> void:
	super.laser_turret_state_enable(turret, animation_player, laser_sprite, laser_raycast)
	
	_turret.set_ID_accessible(true)
	_turret.get_force_field().set_penetrable(true)

	$ShockTimer.start()

func _on_shock_timer_timeout() -> void:
	_done = true
