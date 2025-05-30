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

func lightning_state_enable(lightning: Lightning, sprite: Sprite2D, animation_player: AnimationPlayer) -> void:
	super.lightning_state_enable(lightning, sprite, animation_player)
	
	animation_player.play("lightning_go")

	$GoSfx.play()

	_transition = false
	$TransitionTimer.start()

	if _lightning.on_player():
		StatManager.change_stat("speed_mult", _altered_speed_mult)

func _on_transition_timer_timeout() -> void:
	if _lightning.on_player():
		StatManager.revert_stat_change("speed_mult", _altered_speed_mult)
	
	_transition = true

func get_altered_speed_mult() -> float:
	return _altered_speed_mult
