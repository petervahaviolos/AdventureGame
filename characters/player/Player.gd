extends KinematicBody2D

signal coin_collected
signal health_updated(new_health)

var health = 100
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
var font
var is_attacking = false
var is_moving = false
var is_hit = false

export var max_speed = 40

onready var animation_player = $AnimationPlayer
onready var animation_tree = $Animator
onready var animator = animation_tree.get("parameters/playback")
onready var attack_timer = $AttackTimer
onready var hit_timer = $HitTimer
onready var melee_collider = get_node("MeleePivot").get_child(0).get_child(0)
onready var player_collider = $Collider
onready var player_sprite = $PlayerSprites
onready var state_machine = $StateMachine


func _ready():
	add_to_group("players")


func _on_MeleeArea_body_entered(body):
	body.take_damage(1)


func apply_movement():
	velocity = move_and_slide(velocity)


func handle_move_input():
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	velocity = input_vector * max_speed


func update_blend_position(animation_name):
	animation_tree.set("parameters/" + animation_name + "/blend_position", input_vector)


func get_blend_position(animation_name):
	return animation_tree.get("parameters/" + animation_name + "/blend_position")


func take_damage(damage):
	is_hit = true
	health -= damage
	emit_signal("health_updated", health)


func save():
	var save_data = {
		"name": get_name(),
		"filename": get_filename(),
		"health": health,
		"parent": get_parent().get_path(),
		"position": get_position(),
		"state": state_machine.state
	}
	return save_data


func load(data):
	health = data.get("health")
	position = data.get("position")
	state_machine.set_state(data.get("state"))
