extends Panel

@export var _level_idx: int
@export var _room_idx: int

func _ready() -> void:
	EventBus.change_room.connect(_on_room_change)

func _on_room_change(level_idx: int, room_idx: int) -> void:
	if _level_idx == level_idx and _room_idx == room_idx:
		visible = true
		$PlayerIcon.visible = true
	else:
		$PlayerIcon.visible = false
