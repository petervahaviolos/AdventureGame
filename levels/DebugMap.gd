extends Node2D

onready var scene_manager = get_parent()
onready var connection_manager = null

func _ready():
	print("Lobby ID: " + str(Global.LOBBY_ID))
	print("Number of players: " + str(len(Global.LOBBY_MEMBERS)))
	print("Player data: " + str(Global.LOBBY_MEMBERS))

	if Global.LOBBY_ID != 0:
		connection_manager = scene_manager.get_node("ConnectionManager")


func _physics_process(delta):
	pass
