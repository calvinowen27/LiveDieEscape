extends Panel

@export var _level_idx: int

func _ready() -> void:
	EventBus.change_room.connect(_on_room_change)

func _on_room_change(level_idx: int, _room_idx: int) -> void:
	if _level_idx == level_idx:
		visible = true
	else:
		visible = false
