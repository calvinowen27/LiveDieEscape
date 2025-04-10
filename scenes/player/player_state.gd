extends State

class_name PlayerState

var _rigidbody: RigidBody2D
var _sprite: Sprite2D
var _animation_player: AnimationPlayer

var _move_dir: Vector2

var _can_dash = true

func _ready() -> void:
	# _set_curr_state("PlayerIdle")
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
		var rigidbody = get_parent()
		var sprite = rigidbody.get_node("Sprite2D")
		var animation_player = rigidbody.get_node("AnimationPlayer")
		_curr_state.player_state_enable(sprite, rigidbody, animation_player)

	return new_state

# enable state and pass necessary references
func player_state_enable(sprite: Sprite2D, rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	_sprite = sprite
	_rigidbody = rigidbody
	_animation_player = animation_player
	
	super.enable()

# move player based on input via rigidbody linear velocity
# also update last_move_dir for dashing from idle state
func move() -> void:
	var new_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if new_dir != _move_dir and _move_dir != Vector2.ZERO:
		_rigidbody.set_last_move_dir(_move_dir)
	
	_move_dir = new_dir
	
	var speed = StatManager.get_stat("speed")
	var speed_mult = StatManager.get_stat("speed_mult")

	# what is this why are there no constants
	_rigidbody.linear_velocity = _move_dir * (150 + speed * 20) * speed_mult

func _on_room_change(_level_idx: int, _room_idx):
	# to prevent dash through door bug
	_set_curr_state("PlayerWalk")
