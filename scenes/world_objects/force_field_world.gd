extends Node2D

class_name ForceField

@export var _temporary: bool = true
@export var _penetrable: bool = true

@onready var _rigidbody: RigidBody2D = $RigidBody2D

func _ready() -> void:
	set_penetrable(_penetrable)

func _on_timer_timeout() -> void:
	if _temporary:
		self.queue_free()

func _handle_projectile(body: Node2D) -> void:
	# basically if it's a projectile kill it (can't do this through the projectile rigidbody for some reason)
	if (body as Projectile) != null:
		body.queue_free()

func _on_area_2d_body_entered(body:Node2D) -> void:
	_handle_projectile(body)

func set_penetrable(val: bool) -> void:
	_penetrable = val
	if _penetrable:
		_rigidbody.set_collision_layer_value(1, false)
	else:
		_rigidbody.set_collision_layer_value(1, true)

func is_penetrable() -> bool:
	return _penetrable
