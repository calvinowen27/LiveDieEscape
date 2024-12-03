extends LightningState

@export var _altered_speed_mult: float = 0.5

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func lightning_state_enable(animation_player: AnimationPlayer, sprite: Sprite2D) -> void:
	super.lightning_state_enable(animation_player, sprite)
	
	animation_player.play("lightning_buzz")
	$AliveTimer.start()

	StatManager.change_stat("speed_mult", _altered_speed_mult)

func _on_alive_timer_timeout() -> void:
	StatManager.revert_stat_change("speed_mult", _altered_speed_mult)

	get_node("../../").die()

