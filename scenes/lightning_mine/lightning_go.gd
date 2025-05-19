extends LightningState

@export var _altered_speed_mult: float = 0.0625

var _transition: bool = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func update(_delta: float) -> String:
	if !_transition:
		return super.update(_delta)
	
	return "LightningBuzz"

func lightning_state_enable(sprite: Sprite2D, animation_player: AnimationPlayer) -> void:
	super.lightning_state_enable(sprite, animation_player)
	
	animation_player.play("lightning_go")

	_transition = false
	$TransitionTimer.start()

	StatManager.change_stat("speed_mult", _altered_speed_mult)

func _on_transition_timer_timeout() -> void:
	StatManager.revert_stat_change("speed_mult", _altered_speed_mult)
	_transition = true

func get_altered_speed_mult() -> float:
	return _altered_speed_mult
