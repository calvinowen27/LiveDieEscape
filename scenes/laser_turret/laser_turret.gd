extends RigidBody2D

class_name LaserTurret

var _item_dropped: bool = false

func _ready() -> void:
	$ZOrdering.init($Sprite2D)
	$RayCast2D/Laser.visible = false

	$Interactable.set_active(false)

func reboot() -> void:
	$LaserTurretState.reboot()

func disable_turret() -> void:
	$LaserTurretState.disable_turret()

	if not _item_dropped:
		$Interactable.set_active(true)

func die() -> void:
	$LaserTurretState.die()

func enable_turret() -> void:
	$LaserTurretState.enable_turret()

	$Interactable.set_active(false)

func _on_interactable_interact() -> void:
	var ff = $ForceFieldWorld
	remove_child(ff)
	ff.queue_free()

	_item_dropped = true

	RoomManager.instantiate_item("force_field_emitter", position + Vector2(0, 60))
