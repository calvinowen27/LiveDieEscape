extends PlayerState

var move_dir: Vector2
@export var speed = 2

func _ready() -> void:
	super._ready()
	
	$AnimatedSprite2D.animation = "player_walk"

func _process(delta: float) -> void:
	super._physics_process(delta)
	
	move_dir = Input.get_vector("move_right", "move_left", "move_up", "move_down")
	
	$RigidBody2D.linear_velocity = move_dir * (150 + speed * 10)
	#print($RigidBody2D.position)
	
	#print("processing")
