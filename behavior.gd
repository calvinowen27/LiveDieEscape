extends Node

class_name Behavior

var _curr_behavior: Behavior

var _is_enabled = false

func _ready() -> void:
	disable()

func _process(delta: float) -> void:
	pass

# disable current behavior and set new one
func _set_curr_behavior(new_behavior: Behavior) -> void:
	if _curr_behavior != null:
		_curr_behavior.disable()
	
	_curr_behavior = new_behavior
	_curr_behavior.enable()

func disable() -> void:
	set_process(false)
	_is_enabled = false

func enable() -> void:
	set_process(true)
	_is_enabled = true
