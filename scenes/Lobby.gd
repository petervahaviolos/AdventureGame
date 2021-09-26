extends Control

enum lobby_status { Private, Friends, Public, Invisible }
enum search_distance { Close, Default, Far, Worldwide }

onready var players = $Margin/LobbyParts/Middle/Players
onready var player_1_panel = $Margin/LobbyParts/Middle/Players/Player1Panel
onready var player_2_panel = $Margin/LobbyParts/Middle/Players/Player2Panel
onready var player_3_panel = $Margin/LobbyParts/Middle/Players/Player3Panel
onready var player_4_panel = $Margin/LobbyParts/Middle/Players/Player4Panel
onready var lobby_name_label = $Margin/LobbyParts/Top/MarginContainer/MarginContainer/LobbyNameLabel

onready var scene_manager = get_parent()
onready var connection_manager = scene_manager.get_node("ConnectionManager")


func _ready():
	Steam.connect("lobby_created", self, "_on_Lobby_Created")
	Steam.connect("lobby_match_list", self, "_on_Lobby_Match_List")
	Steam.connect("lobby_joined", self, "_on_Lobby_Joined")
	Steam.connect("lobby_chat_update", self, "_on_Lobby_Chat_Update")
	Steam.connect("lobby_message", self, "_on_Lobby_Message")
	Steam.connect("lobby_data_update", self, "_on_Lobby_Data_Update")
	Steam.connect("join_requested", self, "_on_Lobby_Join_Requested")


##########################
#Lobby Functions         #
##########################
func create_lobby():
	if Global.LOBBY_ID == 0:
		scene_manager.load_scene("ConnectionManager.tscn")
		Steam.createLobby(lobby_status.Public, 4)


func join_lobby(lobby_id):
	Global.LOBBY_MEMBERS.clear()
	Steam.joinLobby(lobby_id)


func leave_lobby():
	if Global.LOBBY_ID != 0:
		Steam.leaveLobby(Global.LOBBY_ID)
		Global.LOBBY_ID = 0
		lobby_name_label.set_text("Lobby Name")
		for member in Global.LOBBY_MEMBERS:
			Steam.closeP2PSessionWithUser(member['steam_id'])

		Global.LOBBY_MEMBERS.clear()


func get_lobby_members():
	Global.LOBBY_MEMBERS.clear()
	for i in range(1, 3):
		var player_panel = players.get_node("Player" + str(i) + "Panel")
		player_panel.set_visible(false)
	var MEMBER_COUNT = Steam.getNumLobbyMembers(Global.LOBBY_ID)

	for member in range(MEMBER_COUNT):
		var MEMBER_STEAM_ID = Steam.getLobbyMemberByIndex(Global.LOBBY_ID, member)
		var MEMBER_STEAM_NAME = Steam.getFriendPersonaName(MEMBER_STEAM_ID)
		add_player(member, MEMBER_STEAM_ID, MEMBER_STEAM_NAME)


func add_player(player_number, steam_id, steam_name):
	Global.LOBBY_MEMBERS.append(
		{"steam_id": steam_id, "steam_name": steam_name, "player_number": player_number}
	)
	var player_panel = players.get_node("Player" + str(player_number + 1) + "Panel")
	player_panel.set_visible(true)
	player_panel.get_node("NameLabel").set_text(steam_name)


##########################
#Steam Callback Functions#
##########################
func _on_Lobby_Created(connect, lobby_id):
	if connect == 1:
		Global.LOBBY_ID = lobby_id
		print("Created a lobby with ID: " + str(lobby_id))

		Steam.setLobbyJoinable(Global.LOBBY_ID, true)

		#Set Lobby Data
		Steam.setLobbyData(lobby_id, "name", Global.STEAM_USERNAME + "'s Lobby")
		var name = Steam.getLobbyData(lobby_id, "name")
		lobby_name_label.set_text(name)

		player_1_panel.get_node("NameLabel").set_text(Global.STEAM_USERNAME)


func _on_Lobby_Joined(lobby_id, permissions, locked, response):
	Global.LOBBY_ID = lobby_id

	var name = Steam.getLobbyData(lobby_id, "name")
	lobby_name_label.text = name

	get_lobby_members()


func _on_Lobby_Join_Requested(lobby_id, friend_id):
	#var OWNER_NAME = Steam.getFriendPersonaName(friend_id)
	join_lobby(lobby_id)


func _on_Lobby_Data_Update(success, lobby_id, member_id, key):
	print(
		(
			"Success: "
			+ str(success)
			+ ", Lobby ID: "
			+ str(lobby_id)
			+ ", Member ID: "
			+ str(member_id)
			+ ", Key: "
			+ str(key)
		)
	)


func _on_Lobby_Chat_Update(lobby_id, changed_id, making_change_id, chat_state):
	var CHANGER = Steam.getFriendPersonaName(making_change_id)

	if chat_state == 1:
		print(str(CHANGER) + " has joined the lobby")
	elif chat_state == 2:
		print(str(CHANGER) + " has left the lobby")
	elif chat_state == 8:
		print(str(CHANGER) + " has been kicked from the lobby")
	elif chat_state == 16:
		print(str(CHANGER) + " has been banned from the lobby")
	else:
		print(str(CHANGER) + " did... something...")

	#Update the lobby
	get_lobby_members()

##########################
#Button Functions        #
##########################
func _on_LeaveButton_pressed():
	leave_lobby()
	scene_manager.get_node("ConnectionManager").queue_free()
	scene_manager.load_scene("MainMenu.tscn")
	queue_free()


func _on_StartButton_pressed():
	connection_manager.send_p2p_packet("all", "game_start")
	scene_manager.load_level("DebugMap.tscn")
	queue_free()


##########################
#Command Line Arugments  #
##########################
func _check_Command_Line():
	var ARGUMENTS = OS.get_cmdline_args()

	if ARGUMENTS.size() > 0:
		for argument in ARGUMENTS:
			print("Command line: " + str(argument))

			if Global.LOBBY_INVITE_ARG:
				join_lobby(int(argument))

			if argument == "+connect_lobby":
				Global.LOBBY_INVITE_ARG = true
