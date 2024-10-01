extends PlayerBehavior

func _ready() -> void:
	_set_curr_behavior($PlayerIdle)

func _process(delta: float) -> void:
	# if detect any movement input, switch to walk behavior
	if  _curr_behavior.name == "PlayerIdle" and (Input.is_action_pressed("move_up") or \
		Input.is_action_pressed("move_down") or \
		Input.is_action_pressed("move_right") or \
		Input.is_action_pressed("move_left")):
			_set_curr_behavior($PlayerWalk)
