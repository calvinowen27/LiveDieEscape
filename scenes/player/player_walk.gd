extends PlayerState

var move_dir: Vector2

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func state_init() -> void:
	super.state_init()
	_animated_sprite.animation = "player_walk"
	_animated_sprite.play()

func update(delta: float) -> String:
	move_dir = move(1)
	
	point_sprite(move_dir)
	
	# not moving anymore --> idle
	if move_dir == Vector2.ZERO:
		return "PlayerIdle"
	
	var has_endurance = StatManager.get_stat("endurance") > 1
	
	# start running --> run
	if Input.is_action_pressed("run") and has_endurance:
		return "PlayerRun"
	
	return name
