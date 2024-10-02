extends PlayerState

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func state_init() -> void:
	super.state_init()
	_animated_sprite.animation = "player_idle"
	_animated_sprite.play()

func update(delta: float) -> String:
	var move_vec = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# movement detected, change to walk state
	if move_vec != Vector2.ZERO:
		return "PlayerWalk"
	
	return name
