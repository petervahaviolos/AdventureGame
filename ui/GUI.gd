extends MarginContainer

var score = 0

onready var score_label = get_node("VBoxContainer/Top/HBoxContainer/Gems/Number")
onready var health_bar = get_node("VBoxContainer/Bottom/Guage")


func _ready():
	pass


func _on_Player_coin_collected():
	score = score + 1
	var score_string = str(score).pad_zeros(4)
	score_label.set_text(score_string)


func _on_Player_damage_taken(damage):
	health_bar.set_value(health_bar.get_value() - damage * 0.72)
