extends MarginContainer

var player = null


func _ready():
	player = get_node("../../YSort/Player")


func _input(event):
	if event.is_action_pressed("ui_pause"):
		change_pause_state()


func _on_Save_pressed():
	DataManager.save_game()


func _on_Quit_pressed():
	pass


func _on_Resume_pressed():
	change_pause_state()


func change_pause_state():
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state
