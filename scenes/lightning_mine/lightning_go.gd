extends LightningState

var _transition: bool = false

@export var _altered_speed: int = -3

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func update(_delta: float) -> String:
	if !_transition:
		return super.update(_delta)
	
	return "LightningBuzz"

func lightning_state_enable(animation_player: AnimationPlayer, sprite: Sprite2D) -> void:
	super.lightning_state_enable(animation_player, sprite)
	
	animation_player.play("lightning_go")

	_transition = false
	$TransitionTimer.start()

	StatManager.change_stat("speed", _altered_speed)

func _on_transition_timer_timeout() -> void:
	StatManager.revert_stat_change("speed", _altered_speed)
	_transition = true
