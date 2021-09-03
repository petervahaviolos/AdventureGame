extends Area2D

onready var animation = $AnimationPlayer
onready var collider = $Collider


func _ready():
	animation.play("idle")


func _on_Coin_body_entered(body):
	collider.set_disabled(true)
	body.emit_signal("coin_collected")
	animation.play("collect")


func save():
	var save_data = {
		"name": get_name(),
		"filename": get_filename(),
		"parent": get_parent().get_path(),
		"position": get_position(),
	}
	return save_data
