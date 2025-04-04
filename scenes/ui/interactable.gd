extends Node2D

class_name Interactable

var _player_in_range = false
var _is_active = true
var _interactable = false

@export var _hold_to_interact = false # if true, duration is $InteractTimer
var _interacting = false

@export var _interact_timer: Timer
@export var _progress_bar: TextureProgressBar

signal interact
signal interactable_set(val: bool)

func _ready() -> void:
	#_interact_timer = $InteractTimer
	#_progress_bar = $InteractLabel/TextureProgressBar

	EventBus.change_room.connect(_on_room_change)

	$InteractLabel.rotation = -rotation
	$InteractLabel.scale.x *= -1 if get_parent().scale.x < 1 else 1
	
	if not _hold_to_interact:
		# _progress_bar.value = _progress_bar.max_value
		_progress_bar.visible = false
		#$InteractLabel.text = "Hold  E  to Interact"

func _process(_delta: float) -> void:
	if _player_in_range and not _interactable:
		if RoomManager.get_player().can_interact_with(self):
			_set_interactable(true)
		else:
			return

	# check for player interaction
	if Input.is_action_just_pressed("interact") and _player_in_range and _is_active:
		if not _hold_to_interact:
			interact.emit()
		elif _interact_timer.is_stopped():
			_interact_timer.start()
			_interacting = true
	
	if _interacting and _is_active:
		if Input.is_action_just_released("interact") or not _player_in_range:
			_interact_timer.stop()
			_interacting = false
			_progress_bar.value = 0
		else:
			_progress_bar.value = _progress_bar.max_value - int(_interact_timer.time_left / _interact_timer.wait_time * _progress_bar.max_value)

func _on_interact_area_body_entered(body: Node2D) -> void:
	var player = RoomManager.get_player()
	if body == player and _is_active:
		_player_in_range = true

		player.add_interactable_touching(self)

		if player.can_interact_with(self):
			_set_interactable(true)

func _on_interact_area_body_exited(body: Node2D) -> void:
	var player = RoomManager.get_player()
	if body == player:
		_player_in_range = false

		player.remove_interactable_touching(self)
		_set_interactable(false)

func _set_interactable(val: bool) -> void:
	$InteractLabel.visible = val
	interactable_set.emit(val)
	_interactable = val

func is_active() -> bool:
	return _is_active

func set_active(val: bool) -> void:
	_is_active = val
	
	if not val:
		$InteractLabel.hide()
		_interacting = false
		_progress_bar.value = 0
	elif _player_in_range:
		$InteractLabel.show()

func _on_interact_timer_timeout() -> void:
	set_active(false)
	interact.emit()
	_interacting = false
	_progress_bar.value = 0

func _on_room_change(_level_idx: int, _room_idx: int) -> void:
	_set_interactable(false)
