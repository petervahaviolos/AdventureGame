extends MarginContainer

var score = 0
var player = null

onready var score_label = get_node("VBoxContainer/Top/HBoxContainer/Gems/Number")
onready var health_bar = get_node("VBoxContainer/Bottom/Guage")


func _ready():
	var player_health = $"../../YSort/Player".health
	health_bar.set_value(player_health + 28)
	get_node("../../YSort/Player").connect("coin_collected", self, "_on_Player_coin_collected")
	get_node("../../YSort/Player").connect("health_updated", self, "_on_Player_health_updated")


func _on_Player_coin_collected():
	score = score + 1
	update_score_label()


func update_score_label():
	var score_string = str(score).pad_zeros(4)
	score_label.set_text(score_string)


func _on_Player_health_updated(health):
	health_bar.set_value(health + 28)


func save():
	var save_data = {
		"name": get_name(),
		"filename": get_filename(),
		"parent": get_parent().get_path(),
		"score": score,
		"rect_position": get_position(),
		"rect_scale": get_scale(),
		"rect_size": get_size()
	}
	return save_data


func load(data):
	rect_position = data.get("rect_position")
	rect_scale = data.get("rect_scale")
	rect_size = data.get("rect_size")
	score = data.get("score")
	update_score_label()
