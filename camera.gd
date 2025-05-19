extends Camera2D

@export var _player: Player

func _process(_delta: float) -> void:
	if _player == null: return

	# print("setting position to ", _player.position)
	position = _player.position
