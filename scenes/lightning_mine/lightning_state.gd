extends State

class_name LightningState

var _animation_player: AnimationPlayer
var _sprite: Sprite2D

func _ready() -> void:
	super._ready()

	EventBus.change_room.connect(_on_room_change)

func _set_curr_state(new_state_name: String) -> State:
	var new_state = super._set_curr_state(new_state_name)
	
	# _curr_state == new_state at this point
	
	if new_state == null:
		return null
	
	# enable new state
	if _curr_state != null:
		var sprite = get_parent()
		var animation_player = sprite.get_node("AnimationPlayer")
		_curr_state.lightning_state_enable(sprite, animation_player)

	return new_state

func lightning_state_enable(sprite: Sprite2D, animation_player: AnimationPlayer) -> void:
	_sprite = sprite
	_animation_player = animation_player

	super.enable()

func _on_room_change(_level_idx: int, _room_idx: int) -> void:
	var new_lightning = load("res://scenes/lightning_mine/lightning.tscn").instantiate()
	RoomManager.get_player().add_child(new_lightning)
	if _curr_state.name == "LightningGo":
		new_lightning.get_node("LightningState/LightningGo/TransitionTimer").wait_time = $LightningGo/TransitionTimer.time_left
		StatManager.revert_stat_change("speed_mult", _curr_state.get_altered_speed_mult())
		get_parent().die()
	elif _curr_state.name == "LightningBuzz":
		new_lightning.get_node("LightningState/LightningGo/TransitionTimer").timeout.emit()
		new_lightning.get_node("LightningState/LightningBuzz/AliveTimer").wait_time = $LightningBuzz/AliveTimer.time_left
		StatManager.revert_stat_change("speed_mult", _curr_state.get_altered_speed_mult())
		get_parent().die()
	