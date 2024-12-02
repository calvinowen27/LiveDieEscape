extends LightningState

var _transition: bool = false

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

	StatManager.set_base_stat("speed", -3)

func _on_transition_timer_timeout() -> void:
	print("transition")
	_transition = true
