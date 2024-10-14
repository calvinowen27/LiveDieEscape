extends State

class_name LaserTurretState

var _animation_player: AnimationPlayer

func _ready() -> void:
	_set_curr_state("LaserTurretPriming")

func _set_curr_state(new_state_name: String) -> State:
	var new_state = super._set_curr_state(new_state_name)
	
	# _curr_state == new_state at this point
	
	if new_state == null:
		return null
	
	# enable new state
	if _curr_state != null:
		var animation_player = get_node("../AnimationPlayer")
		_curr_state.laser_turret_state_enable(animation_player)

	return new_state

func laser_turret_state_enable(animation_player: AnimationPlayer) -> void:
	_animation_player = animation_player
	
	super.enable()

# activate turret when finished priming
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "laser_turret_priming":
		_set_curr_state("LaserTurretActivated")

# activate when player nearby
func _on_activation_area_body_entered(body: Node2D) -> void:
	#if body == RoomManager.get_player():
		#_set_curr_state("LaserTurretPriming")
	pass

# deactivate when player leaves
func _on_activation_area_body_exited(body: Node2D) -> void:
	#if body == RoomManager.get_player():
		#_set_curr_state("LaserTurretIdle")
	pass

func reboot() -> void:
	_set_curr_state("LaserTurretIdle")
	
	await get_tree().create_timer(10).timeout
	
	if _curr_state.name == "LaserTurretIdle":
		_set_curr_state("LaserTurretPriming")
