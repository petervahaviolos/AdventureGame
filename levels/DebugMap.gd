extends Node2D

var player_data = []
onready var scene_manager = get_parent()
onready var connection_manager = null

func _ready():
	if Global.LOBBY_ID != 0:
		connection_manager = scene_manager.get_node("ConnectionManager")
		connection_manager.connect("data_updated", self, "_on_ConnectionManager_data_updated")

		print("Lobby ID: " + str(Global.LOBBY_ID))
		print("Number of players: " + str(len(Global.LOBBY_MEMBERS)))
		print("Player data: " + str(Global.LOBBY_MEMBERS))

		for player in Global.LOBBY_MEMBERS:
			if player['steam_id'] != Global.STEAM_ID:
				var new_player = preload('res://characters/replica_player/ReplicaPlayer.tscn').instance()
				new_player.set_name(str(player['steam_id']))
				new_player.global_position = Vector2(300, 96)
				new_player.get_node("UsernameLabel").text = str(player['steam_name'])
				get_node("YSort/Players").add_child(new_player)
			else:
				get_node("YSort/Players/Player/UsernameLabel").set_text(str(player['steam_name']))

func _on_ConnectionManager_data_updated(packet):
		if typeof(packet['data']) == TYPE_DICTIONARY:
			var player_node = get_node("YSort/Players/" + str(packet['sender']))
			player_node.global_position = Vector2(packet['data']['x'], packet['data']['y'])
			player_node.state_machine._enter_state(packet['data']['state'], player_node.state_machine.state)
			player_node.input_vector = packet['data']['input_vector']
