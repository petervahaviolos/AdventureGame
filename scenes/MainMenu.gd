extends MarginContainer

onready var scene_manager = get_parent()


func _ready():
	pass


func _on_NewGame_pressed():
	scene_manager.load_level("DebugMap.tscn")
	queue_free()


func _on_LoadGame_pressed():
	scene_manager.load_level("DebugMap.tscn")
	DataManager.load_game()
	queue_free()
