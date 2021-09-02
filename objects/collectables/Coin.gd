extends Area2D

onready var animation = $AnimationPlayer
onready var collider = $Collider


func _ready():
	animation.play("idle")


func _on_Coin_body_entered(body):
	collider.set_disabled(true)
	body.emit_signal("coin_collected")
	animation.play("collect")
