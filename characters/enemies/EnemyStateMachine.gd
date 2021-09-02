extends "res://StateMachine.gd"


func _ready():
	add_state("idle")
	add_state("patrol")
	add_state("chase")
	add_state("hurt")
	add_state("death")
	call_deferred("set_state", states.patrol)


func _state_logic(delta):
	match state:
		states.chase:
			parent.move_toward_player()
			parent.apply_movement(delta)
		states.patrol:
			parent.patrol()
			parent.apply_movement(delta)


func _get_transition(_delta):
	match state:
		states.patrol:
			if parent.player != null:
				return states.chase
		states.chase:
			if parent.player == null:
				return states.idle
			if parent.is_hit:
				return states.hurt
		states.idle:
			if parent.idle_timer.is_stopped():
				if parent.player != null:
					return states.chase
				if parent.player == null:
					return states.patrol
		states.hurt:
			if not parent.animation_player.is_playing():
				parent.get_node("Collider").set_disabled(false)
				parent.is_hit = false
				return states.chase
			if parent.health <= 0:
				return states.death
		states.death:
			if not parent.animation_player.is_playing():
				var coin_spawn = parent.coin.instance()
				coin_spawn.set_position(parent.get_position())
				parent.get_parent().get_parent().get_node("Coins").add_child(coin_spawn)
				parent.queue_free()


func _enter_state(new_state, _old_state):
	match new_state:
		states.idle:
			parent.idle_timer.start()
			parent.enemy_state_label.set_text("idle")
			parent.animation_player.play("idle")
		states.patrol:
			parent.enemy_state_label.set_text("patrol")
			parent.animation_player.play("run")
		states.hurt:
			parent.get_node("Collider").set_disabled(true)
			parent.enemy_state_label.set_text("hurt")
			parent.animation_player.play("hit")
		states.death:
			parent.enemy_state_label.set_text("death")
			parent.animation_player.play("death")
		states.chase:
			parent.enemy_state_label.set_text("chase")
			parent.animation_player.play("run")
