extends Node

#func _ready() -> void:
	#print(SceneManager.get_curr_scene())
	#RoomManager.set_curr_room(0, 0)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		RoomManager.get_curr_room().reboot_room()
		print("ok")
