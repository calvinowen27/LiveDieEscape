extends State

class_name LightningState

@export var _animation_player: AnimationPlayer
@export var _sprite: Sprite2D

func _ready() -> void:
	super._ready()

	_set_curr_state("LightningGo")

func _set_curr_state(new_state_name: String) -> State:
	var new_state = super._set_curr_state(new_state_name)
	
	# _curr_state == new_state at this point
	
	if new_state == null:
		return null
	
	# enable new state
	if _curr_state != null:
		_curr_state.lightning_state_enable(_animation_player, _sprite)

	return new_state

func lightning_state_enable(animation_player: AnimationPlayer, sprite: Sprite2D) -> void:
	_animation_player = animation_player
	_sprite = sprite

	super.enable()
