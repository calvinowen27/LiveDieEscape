extends Node

var _is_game_running = false
var _is_game_paused = false

func restart_game() -> void:
	SceneManager.switch_scene_to("ui/title_screen")
	_is_game_running = false

# returns new state of game pause
func toggle_game_paused() -> bool:
	_is_game_paused = !_is_game_paused
	get_tree().paused = _is_game_paused
	return _is_game_paused

func is_game_running() -> bool:
	return _is_game_running

func _ready() -> void:
	EventBus.start_game.connect(_on_game_start)
	EventBus.player_respawn.connect(_on_player_respawn)

func _on_game_start() -> void:
	if not _is_game_running:
		# switch scene to main
		SceneManager.switch_scene_to("main")
		_is_game_running = true
		EventBus.level_reset.emit(RoomManager.get_curr_level())
		RoomManager.set_curr_room(0, 0, -1)

func _on_player_respawn() -> void:
	EventBus.level_reset.emit(0)
