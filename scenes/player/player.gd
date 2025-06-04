extends RigidBody2D

class_name Player

# var _queue_teleport = Vector2.ZERO

var _last_move_dir: Vector2

var _interactables_touching: Array

func _ready() -> void:
	EventBus.change_room.connect(_on_room_change)

	if Fabricator.is_active():
		set_fabricate_range_visible(true)

func _process(_delta: float) -> void:
	if $FabricateRange.visible:
		set_fabricate_point(Game.get_mouse_pos_relative_to(self))

func reset() -> void:
	for child in get_children():
		if child is Lightning:
			child.queue_free()
	
	StatManager.reset_stats()

func die() -> void:
	# EventBus.level_reset.emit(0)
	EventBus.player_death.emit()
	Inventory.clear()

	for child in get_children():
		# print("child ", child)
		if child is Lightning:
			# print("removing lightning")
			remove_child(child)
			child.queue_free()

func _on_room_change(_level_idx: int, _room_idx: int) -> void:
	$PlayerState/DashCooldownTimer.stop()
	$PlayerState/DashCooldownTimer.timeout.emit()

# func queue_teleport(pos: Vector2) -> void:
# 	_queue_teleport = pos

func teleport(pos: Vector2) -> void:
	position = pos
	linear_velocity = Vector2.ZERO

func set_last_move_dir(dir: Vector2) -> void:
	_last_move_dir = dir

func get_last_move_dir() -> Vector2:
	return _last_move_dir

func add_interactable_touching(interactable: Interactable) -> void:
	_interactables_touching.append(interactable)

func remove_interactable_touching(interactable: Interactable) -> void:
	_interactables_touching.erase(interactable)

func can_interact_with(interactable: Interactable) -> bool:
	return interactable in _interactables_touching and _interactables_touching.size() == 1

func _on_shockable_shock(lightning: Lightning) -> void:
	lightning.get_node("LightningState/LightningGo/TransitionTimer").timeout.connect(_on_lightning_transition)

func _on_lightning_transition() -> void:
	Fabricator.learn_recipe("Shock Bomb")

func set_fabricate_range_visible(val: bool) -> void:
	$FabricateRange.visible = val

func set_fabricate_point(point: Vector2) -> void:
	$FabricateRange.set_endpoint(point)
