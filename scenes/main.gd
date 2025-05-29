extends Node

@onready var _hud: HUD = %HUD
@onready var _fab_mat_manager: FabricateMaterialManager = %FabricateMaterialManager

func init() -> void:
	_hud.init()

func get_HUD() -> Control:
	return _hud

func get_camera() -> Camera2D:
	return RoomManager.get_curr_room().get_node("%Camera") as Camera2D

func get_fabricate_material_manager() -> FabricateMaterialManager:
	return _fab_mat_manager
