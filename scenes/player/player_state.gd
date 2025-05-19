extends State

class_name PlayerState

const BASE_SPEED_MULT: int = 20

@export var _character: CharacterBody2D
@export var _sprite: Sprite2D
@export var _animation_player: AnimationPlayer

var _move_dir: Vector2

var _can_dash = true

func _ready() -> void:
	super._ready()

	EventBus.change_room.connect(_on_room_change)

func enable():
	pass

func state_init() -> void:
	pass

func _set_curr_state(new_state_name: String) -> State:
	var new_state = super._set_curr_state(new_state_name)
	
	if new_state == null:
		return null
	
	if _curr_state != null:
		_curr_state.player_state_enable(_sprite, _character, _animation_player)

	return new_state

# enable state and pass necessary references
func player_state_enable(sprite: Sprite2D, character: CharacterBody2D, animation_player: AnimationPlayer) -> void:
	_sprite = sprite
	_character = character
	_animation_player = animation_player
	
	super.enable()

# move player based on input via rigidbody linear velocity
# also update last_move_dir for dashing from idle state
func move() -> void:
	var new_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if new_dir != _move_dir and _move_dir != Vector2.ZERO:
		_character.set_last_move_dir(_move_dir)
	
	_move_dir = new_dir

	var speed = StatManager.get_stat("speed")
	var speed_mult = StatManager.get_stat("speed_mult")
	
	_character.velocity = _move_dir * (speed * BASE_SPEED_MULT) * speed_mult
	_character.move_and_slide()

func _on_room_change(_level_idx: int, _room_idx):
	# to prevent dash through door bug
	_set_curr_state("PlayerWalk")
