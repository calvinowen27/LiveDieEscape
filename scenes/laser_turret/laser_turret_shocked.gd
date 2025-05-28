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
	_turret.set_force_field_penetrable(true)

	laser_sprite.visible = false
	laser_raycast.enabled = false
	
	_laser_raycast.get_node("Spark").visible = false
	_laser_raycast.get_node("SparkEnd").visible = false

	# $ShockTimer.start()

	# TODO: no
	var lightning = load("res://scenes/lightning_mine/lightning.tscn").instantiate()
	turret.add_child(lightning)
	lightning.init(_turret)

	lightning.get_node("LightningState/LightningBuzz/AliveTimer").timeout.connect(_on_shock_timer_timeout)

func _on_shock_timer_timeout() -> void:
	_done = true
