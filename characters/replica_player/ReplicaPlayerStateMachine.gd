extends "res://StateMachine.gd"


func _ready():
	add_state("idle")
	add_state("walk")
	add_state("attack")
	add_state("hit")
	call_deferred("set_state", states.idle)


func _state_logic(_delta):
	if parent.input_vector != Vector2.ZERO:
		parent.update_blend_position("walk")
		parent.update_blend_position("idle")
		parent.update_blend_position("attack")
		parent.update_blend_position("hit")


func _get_transition(_delta):
	pass


func _enter_state(new_state, _old_state):
	match new_state:
		states.idle:
			parent.get_node("StateLabel").set_text("idle")
			parent.animator.travel("idle")
		states.walk:
			parent.get_node("StateLabel").set_text("walk")
			parent.animator.travel("walk")
		states.attack:
			parent.get_node("StateLabel").set_text("attack")
			parent.melee_collider.disabled = false
			parent.attack_timer.start()
			parent.animator.travel("attack")
		states.hit:
			parent.get_node("StateLabel").set_text("hit")
			parent.player_collider.disabled = true
			parent.hit_timer.start()
			parent.animator.travel("hit")


func _exit_state(_old_state, _new_state):
	pass
