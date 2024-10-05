extends State

class_name LaserTurretState

var _animated_sprite: AnimatedSprite2D

func _ready() -> void:
	_set_curr_state("LaserTurretActivated")

func _process(delta: float) -> void:
	pass

func _set_curr_state(new_state_name: String) -> State:
	var new_state = super._set_curr_state(new_state_name)
	
	if new_state == null:
		return null
	
	if _curr_state != null:
		var animated_sprite = get_parent().get_node("AnimatedSprite2D")
		_curr_state.laser_turret_state_enable(animated_sprite)

	return new_state

func laser_turret_state_enable(animated_sprite: AnimatedSprite2D) -> void:
	_animated_sprite = animated_sprite
	
	super.enable()
