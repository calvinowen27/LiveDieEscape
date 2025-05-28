extends RigidBody2D

var _detonating: bool = false

@onready var _animation_player: AnimationPlayer = $AnimationPlayer

var _nodes_in_range: Array[Node2D]

func _ready() -> void:
	# detonate on creation, might change later
	detonate()

func _process(_delta: float) -> void:
	if _detonating:
		# shock all nodes in range (if not shocked already)
		for node in _nodes_in_range:
			if node is LaserTurret:
				node.shock()
		_nodes_in_range.clear()

func _on_alive_timer_timeout() -> void:
	_detonating = false
	_animation_player.play("RESET")

func detonate() -> void:
	_detonating = true
	_animation_player.play("shock_bomb_detonate")
	$AliveTimer.start()

func _on_shock_range_body_entered(body: Node2D) -> void:
	_nodes_in_range.append(body)

func _on_shock_range_body_exited(body: Node2D) -> void:
	if body in _nodes_in_range:
		_nodes_in_range.erase(body)
