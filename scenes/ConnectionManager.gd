extends Node


func _ready():
	Steam.connect("p2p_session_request", self, "_on_P2P_Session_Request")
	Steam.connect("p2p_session_connect_fail", self, "_on_P2P_Session_Connect_Fail")

func _physics_process(_delta):
	read_p2p_packet()

func read_p2p_packet():
	var PACKET_SIZE = Steam.getAvailableP2PPacketSize(0)

	if PACKET_SIZE > 0:
		var PACKET = Steam.readP2PPacket(PACKET_SIZE, 0)
		if PACKET.empty():
			print("[WARNING] Read an empty packet")

		var _PACKET_ID = str(PACKET.steamIDRemote)
		var _PACKET_CODE = str(PACKET.data[0])
		var READABLE = bytes2var(PACKET.data.subarray(1, PACKET_SIZE - 1))

		print("[STEAM] Packet: " + str(READABLE))


func send_p2p_packet(target, packet_data):
	var SEND_TYPE = 2
	var CHANNEL = 0

	var PACKET_DATA = []
	PACKET_DATA.append(256)
	PACKET_DATA.append_array(var2bytes(packet_data))

	var SEND_RESPONSE
	if target == "all":
		if Global.LOBBY_MEMBERS.size() > 1:
			for member in Global.LOBBY_MEMBERS:
				if member['steam_id'] != Global.STEAM_ID:
					SEND_RESPONSE = Steam.sendP2PPacket(
						member['steam_id'], PACKET_DATA, SEND_TYPE, CHANNEL
					)
	else:
		SEND_RESPONSE = Steam.sendP2PPacket(int(target), PACKET_DATA, SEND_TYPE, CHANNEL)

	print("[STEAM] P2P packet sent successfully? " + str(SEND_RESPONSE))


func make_p2p_handshake():
	print("[STEAM] Sending P2P handshake to the lobby...")
	send_p2p_packet("all", {"message": "handshake", "from": Global.STEAM_ID})


func send_test_info():
	print("[STEAM] Sending test packet data")
	var TEST_DATA = {
		"title": "This is a test packet",
		"player_id": Global.STEAM_ID,
		"player_hp": "5",
		"player_pos": "56,40"
	}
	send_p2p_packet("all", TEST_DATA)

func _on_P2P_Session_Request(remote_id):
	var REQUESTER = Steam.getFriendPersonaName(remote_id)
	print("[STEAM] P2P Session request from: " + str(REQUESTER))

	var SESSION_ACCEPTED = Steam.acceptP2PSessionWithUser(remote_id)
	print("[STEAM] P2P session was connected: " + str(SESSION_ACCEPTED))

	make_p2p_handshake()


func _on_P2P_Session_Connect_Fail(lobby_id, session_error):
	#No error
	if session_error == 0:
		print("[WARNING] Session failure with " + str(lobby_id) + " [no error given]")
	#Target user was not running the same game
	elif session_error == 1:
		print(
			(
				"[WARNING] Session failure with "
				+ str(lobby_id)
				+ " [target user not running the same game]"
			)
		)
	#Local user does not own the game
	elif session_error == 2:
		print(
			(
				"[WARNING] Session failure with "
				+ str(lobby_id)
				+ " [local user does not own the game]"
			)
		)
	#Target user isn't connected to Steam
	elif session_error == 3:
		print(
			(
				"[WARNING] Session failure with "
				+ str(lobby_id)
				+ " [target user isn't connected to Steam]"
			)
		)
	#Connection timed out
	elif session_error == 4:
		print("[WARNING] Session failure with " + str(lobby_id) + " [connection timed out]")
	#Unused
	elif session_error == 5:
		print("[WARNING] Session failure with " + str(lobby_id) + " [unused]")
	#Unknown error
	else:
		print(
			(
				"[WARNING] Session failure with "
				+ str(lobby_id)
				+ " [unknown error "
				+ str(session_error)
				+ " ]"
			)
		)
