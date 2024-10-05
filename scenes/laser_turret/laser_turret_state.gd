extends State

class_name LaserTurretState

var _animation_player: AnimationPlayer

func _ready() -> void:
	_set_curr_state("LaserTurretIdle")

#func _process(delta: float) -> void:
	#pass

func _set_curr_state(new_state_name: String) -> State:
	var new_state = super._set_curr_state(new_state_name)
	
	if new_state == null:
		return null
	
	if _curr_state != null:
		var animation_player = get_parent().get_node("AnimationPlayer")
		_curr_state.laser_turret_state_enable(animation_player)

	return new_state

func laser_turret_state_enable(animation_player: AnimationPlayer) -> void:
	_animation_player = animation_player
	
	super.enable()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "laser_turret_priming":
		_set_curr_state("LaserTurretActivated")
