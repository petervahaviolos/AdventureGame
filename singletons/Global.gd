extends Node

var IS_ONLINE: bool = false
var IS_OWNED: bool = false
var STEAM_ID: int = 0
var STEAM_USERNAME: String = ""

var DATA
var LOBBY_ID = 0
var LOBBY_MEMBERS = []
var LOBBY_INVITE_ARG = false


func _ready():
	_initialize_Steam()


func _process(_delta):
	Steam.run_callbacks()


func _initialize_Steam():
	var INIT: Dictionary = Steam.steamInit()
	print("Did steam initialize?: " + str(INIT))

	if INIT['status'] != 1:
		print("Failed to initialize Steam: " + str(INIT['status']) + " Shutting down")
		get_tree().quit()

	IS_ONLINE = Steam.loggedOn()
	STEAM_ID = Steam.getSteamID()
	IS_OWNED = Steam.isSubscribed()
	STEAM_USERNAME = Steam.getPersonaName()

	#if IS_OWNED == false:
		#print("User does not own this game")
		#get_tree().quit()
