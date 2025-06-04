extends Node

var _is_game_running = false
var _is_game_paused = false
var _is_player_dead = false

var _main: Node

func restart_game() -> void:
	SceneManager.switch_scene_to("ui/title_screen")
	_is_game_running = false
	Fabricator.clear_materials()

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
	EventBus.player_death.connect(_on_player_death)

func _on_game_start() -> void:
	if not _is_game_running:
		# switch scene to main
		SceneManager.switch_scene_to("main")
		_main = get_tree().root.get_node("Main")
		_main.init()

		_is_game_running = true
		EventBus.level_reset.emit(RoomManager.get_curr_level())
		RoomManager.set_curr_room(0, 0, -1)

func _on_player_respawn() -> void:
	# EventBus.level_reset.emit(0)
	_is_player_dead = false

func _on_player_death() -> void:
	_is_player_dead = true

func is_player_dead() -> bool:
	return _is_player_dead

func get_HUD() -> HUD:
	return _main.get_HUD()

func get_camera() -> Camera2D:
	return _main.get_camera()

func get_fabricate_material_manager() -> FabricateMaterialManager:
	return _main.get_fabricate_material_manager()

# returns mouse position relative to target, or relative to camera if target is null
func get_mouse_pos_relative_to(target: Node2D) -> Vector2:
	var camera = get_camera()
	var mouse_pos_from_cam = camera.get_local_mouse_position() + camera.position

	if target == null:
		return mouse_pos_from_cam
	else:
		return mouse_pos_from_cam - target.position
