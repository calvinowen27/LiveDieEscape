extends State

class_name PlayerState

var _rigidbody: RigidBody2D
var _animated_sprite: AnimatedSprite2D

func _ready() -> void:
	_set_curr_state(get_node("PlayerIdle"))

func _process(delta: float) -> void:
	if _curr_state != null:
		var next_state_name = _curr_state.update(delta)
		if next_state_name != _curr_state.name:
			_set_curr_state(get_node(next_state_name))

func enable():
	pass

func state_init() -> void:
	pass

func _set_curr_state(new_state: State) -> void:
	super._set_curr_state(new_state)
	
	if _curr_state != null:
		_curr_state.player_enable(get_parent(), get_parent().get_node("AnimatedSprite2D"))

func player_enable(rigidbody: RigidBody2D, animated_sprite: AnimatedSprite2D) -> void:
	_rigidbody = rigidbody
	_animated_sprite = animated_sprite
	
	super.enable()
