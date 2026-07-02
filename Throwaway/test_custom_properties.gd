@tool
extends EditorScenePostImport


# Called when the node enters the scene tree for the first time.
func _post_import(scene: Node) -> Object:
	print("meta_list is: " + str(get_meta_list()))


#func post_import(scene):
	var json = JSON.new()
	json.parse(_get_content(get_source_file()))
	print("json variable is: " + str(json))
	var j_data = json.data 
	print("json_data: " + str(j_data))
	#process_children_nodes(scene, scene, nodes_json)
	return scene
	
func _get_content(path) -> String:
	print("import path is: " + str(path))
	var file = FileAccess.open(path, FileAccess.READ)
	print(file)
	var content = file.get_as_text()
	file.close()
	print("get_content: content is: " + str(content))
	return content

func custom_properties_for(node, nodes_json):
	var node_json = find_json_node_for(node, nodes_json)
	
	if node_json and node_json.has("extras"):
		return node_json["extras"]
	else:
		return {}

func find_json_node_for(node, nodes_json):
	for node_json in nodes_json:
		if normalized_json_node_name(node_json["name"]) == node.name:
			return node_json

# It is working for us so far.
func normalized_json_node_name(node_name: String):
	var suffix_regex := RegEx.new()
	
	assert(
		suffix_regex.compile("-col(only)?(\\d*)$") == OK,
		"Error compiling regex!"
	)

	return suffix_regex.sub(node_name.replace(".", ""), "$2")
