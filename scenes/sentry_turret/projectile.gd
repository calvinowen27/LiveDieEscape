extends RigidBody2D

var _parent

func init_projectile(parent: Node2D, linear_velocity_: Vector2) -> void:
	linear_velocity = linear_velocity_
	_parent = parent

func _ready() -> void:
	apply_torque(100000)

func _on_alive_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body == _parent:
		return
	
	var player = RoomManager.get_player()
	if body == player:
		player.die()
	
	queue_free()
