extends LightningState

@export var _altered_speed_mult: float = 0.5

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func lightning_state_enable(sprite: Sprite2D, animation_player: AnimationPlayer) -> void:
	super.lightning_state_enable(sprite, animation_player)
	
	animation_player.play("lightning_buzz")
	$AliveTimer.start()

	StatManager.change_stat("speed_mult", _altered_speed_mult)

func _on_alive_timer_timeout() -> void:
	StatManager.revert_stat_change("speed_mult", _altered_speed_mult)

	_sprite.die()

func get_altered_speed_mult() -> float:
	return _altered_speed_mult
