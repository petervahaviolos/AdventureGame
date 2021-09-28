extends KinematicBody2D

var input_vector = Vector2.ZERO
var is_attacking = false
var is_hit = false

onready var animation_tree = $Animator
onready var animator = animation_tree.get("parameters/playback")
onready var attack_timer = $AttackTimer
onready var hit_timer = $HitTimer
onready var melee_collider = get_node("MeleePivot").get_child(0).get_child(0)
onready var player_collider = $Collider
onready var state_machine = $StateMachine

func _ready():
	add_to_group("players")


func _on_MeleeArea_body_entered(body):
	body.take_damage(1)

func update_blend_position(animation_name):
	animation_tree.set("parameters/" + animation_name + "/blend_position", input_vector)


func get_blend_position(animation_name):
	return animation_tree.get("parameters/" + animation_name + "/blend_position")

func take_damage(damage):
	pass
