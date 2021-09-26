extends Node

var map_start = preload("res://scenes/MainMenu.tscn")
var current_scene = map_start


func _ready():
	var map_start_instance = map_start.instance()
	add_child(map_start_instance)


func load_level(level_name):
	var level_to_load = load("res://levels/" + level_name).instance()
	add_child(level_to_load)


func send_data(level_name, data_to_send):
	var level = get_node(level_name)
	level.receieve_data(data_to_send)


func load_scene(scene_name):
	var scene_to_load = load("res://scenes/" + scene_name).instance()
	add_child(scene_to_load)
