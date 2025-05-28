extends LightningState

@export var _altered_speed_mult: float = 0.5

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func update(_delta: float) -> String:
	$BuzzSfx.volume_db = -2 * $AliveTimer.wait_time / $AliveTimer.time_left
	
	return "LightningBuzz"

func lightning_state_enable(lightning: Lightning, sprite: Sprite2D, animation_player: AnimationPlayer) -> void:
	super.lightning_state_enable(lightning, sprite, animation_player)
	
	animation_player.play("lightning_buzz")
	$AliveTimer.start()

	if _lightning.on_player():
		StatManager.change_stat("speed_mult", _altered_speed_mult)

func _on_alive_timer_timeout() -> void:
	if _lightning.on_player():
		StatManager.revert_stat_change("speed_mult", _altered_speed_mult)

	_sprite.die()

func get_altered_speed_mult() -> float:
	return _altered_speed_mult
