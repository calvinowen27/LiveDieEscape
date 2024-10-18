extends Node2D

class_name Interactable

var _player_in_range = false
var _is_active = true

@export var _hold_to_interact = false # if true, duration is $InteractTimer
var _interacting = false

var _interact_timer: Timer
var _progress_bar: TextureProgressBar

signal interact
signal interactable_set(val: bool)

func _ready() -> void:
	_interact_timer = $InteractTimer
	_progress_bar = $InteractLabel/TextureProgressBar
	
	if not _hold_to_interact:
		_progress_bar.value = _progress_bar.max_value
		#$InteractLabel.text = "Hold  E  to Interact"

func _process(_delta: float) -> void:
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
	if body == RoomManager.get_player() and _is_active:
		_set_interactable(true)

func _on_interact_area_body_exited(body: Node2D) -> void:
	if body == RoomManager.get_player():
		_set_interactable(false)

func _set_interactable(val: bool) -> void:
	_player_in_range = val
	$InteractLabel.visible = val
	interactable_set.emit(val)

func is_active() -> bool:
	return _is_active

func set_active(val: bool) -> void:
	_is_active = val
	
	if not val:
		$InteractLabel.visible = false

func _on_interact_timer_timeout() -> void:
	interact.emit()
	_interacting = false
	set_active(false)
