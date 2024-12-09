extends RigidBody2D

var _player_touching = false

func _ready() -> void:
	$AnimationPlayer.play("acid_bubble")

func _on_edge_timer_timeout() -> void:
	$CollisionShape2D.set_deferred("disabled", true)

func _on_rigid_body_2d_body_entered(body: Node) -> void:
	if body == RoomManager.get_player():
		$EdgeTimer.start()

func _on_lethal_area_body_entered(body: Node2D) -> void:
	if body == RoomManager.get_player():
		body.die()

func _on_total_area_body_exited(body: Node2D) -> void:
	if body == RoomManager.get_player():
		$EdgeTimer.stop()
		$CollisionShape2D.set_deferred("disabled", false)
