extends Node

class_name State

var _curr_state: State

var _is_enabled = false

func _ready() -> void:
	disable()

func _process(delta: float) -> void:
	#if _curr_state != null:
		#_curr_state.update(delta)
	if _curr_state != null:
		var next_state_name = _curr_state.update(delta)
		if next_state_name != _curr_state.name:
			_set_curr_state(next_state_name)

# returns name of next state
func update(_delta: float) -> String:
	return name

# disable current behavior and set new one
func _set_curr_state(new_state_name: String) -> State:
	if _curr_state != null:
		_curr_state.disable()
	
	var new_state = get_node(new_state_name)
	
	if new_state == null:
		print_debug("state: _set_curr_state(): state %s not found" % new_state_name)
		return null
	
	_curr_state = new_state
	if _curr_state != null:
		_curr_state.enable()
	
	return _curr_state

func state_init() -> void:
	pass

func get_curr_state() -> State:
	return _curr_state

func disable() -> void:
	set_process(false)
	set_physics_process(false)
	_is_enabled = false

func enable() -> void:
	set_process(true)
	set_physics_process(true)
	_is_enabled = true
	state_init()
