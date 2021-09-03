extends Node

var save_path = "user://save.dat"


func _ready():
	pass


func save_game():
	var save_data = []
	var file = File.new()
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		for node in save_nodes:
			var node_data = node.call("save")
			save_data.append(node_data)
		file.store_var(save_data)
		file.close()


func load_game():
	var file = File.new()
	if not file.file_exists(save_path):
		return

	var error = file.open(save_path, File.READ)
	if error == OK:
		var save_nodes = get_tree().get_nodes_in_group("Persist")
		for node in save_nodes:
			node.free()

		for node_data in file.get_var():
			var new_object = load(node_data["filename"]).instance()
			get_node(node_data["parent"]).add_child(new_object)
			new_object.set_name(node_data["name"])

			if new_object.has_method("load"):
				new_object.load(node_data)
			else:
				for i in node_data.keys():
					if i == "filename" or i == "parent" or "name":
						continue

					new_object.set(i, node_data[i])

		file.close()
