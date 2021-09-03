extends KinematicBody2D

var player = null
var velocity = Vector2.ZERO
var patrol_points
var patrol_index = 0
var is_hit = false

export var damage = 0

onready var hitbox_collider = $HitBox/Collider
onready var enemy_collider = $Collider
onready var animation_player = $AnimationPlayer
onready var enemy_state_label = $EnemyState
onready var idle_timer = $IdleTimer
onready var coin = preload("res://objects/collectables/Coin.tscn")
onready var state_machine = $StateMachine

export var max_speed = 200
export (NodePath) var patrol_path
export (int) var health = 3


func _ready():
	if patrol_path:
		patrol_points = get_node(patrol_path).curve.get_baked_points()


func patrol():
	if ! patrol_path:
		return

	var target = patrol_points[patrol_index]
	if position.distance_to(target) < 1:
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
		target = patrol_points[patrol_index]
	velocity = (target - position).normalized() * max_speed


func apply_movement(delta):
	velocity = move_and_slide(velocity * delta)


func move_toward_player():
	if player == null:
		return

	var target_position = player.get_global_position()
	var starting_position = get_global_position()
	velocity = (target_position - starting_position).normalized() * max_speed


func take_damage(p_damage):
	health -= p_damage
	is_hit = true


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


func _on_ChaseArea_body_entered(body):
	player = body


func _on_ChaseArea_body_exited(_body):
	player = null


func _on_HitBox_body_entered(body):
	body.take_damage(damage)
