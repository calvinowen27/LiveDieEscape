extends LightningState

@export var _altered_speed: int = 0

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func lightning_state_enable(animation_player: AnimationPlayer, sprite: Sprite2D) -> void:
	super.lightning_state_enable(animation_player, sprite)
	
	animation_player.play("lightning_buzz")
	$AliveTimer.start()

	StatManager.change_stat("speed", _altered_speed)

func _on_alive_timer_timeout() -> void:
	StatManager.revert_stat_change("speed", _altered_speed)

	get_node("../../").die()

