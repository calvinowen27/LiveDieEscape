extends Node

class_name State

var _curr_state: State

var _is_enabled = false

func _ready() -> void:
	disable()

func _process(delta: float) -> void:
	if _curr_state != null:
		_curr_state.update(delta)

# returns name of next state
func update(delta: float) -> String:
	return name

# disable current behavior and set new one
func _set_curr_state(new_state: State) -> void:
	if _curr_state != null:
		_curr_state.disable()
	
	_curr_state = new_state
	if _curr_state != null:
		_curr_state.enable()

func state_init() -> void:
	pass

func disable() -> void:
	set_process(false)
	set_physics_process(false)
	_is_enabled = false

func enable() -> void:
	set_process(true)
	set_physics_process(true)
	_is_enabled = true
	state_init()
