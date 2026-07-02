@tool
extends Node

# an interface that the main codebase references when performing debug operations 
var edge_collisions = false
var animations = false

signal collision()
var moused_debug_panel = null


func load_highlight(local_pos: Vector3, highlight_parent, clr = Color.WHITE):

	var highlight : MeshInstance3D = load("res://Debug/highlight_ball.tscn").instantiate()
	if clr != Color.WHITE:
		#highlight.get_surface_override_material(0).make
		highlight.material_override.albedo_color = clr
	highlight_parent.add_child(highlight)
	highlight.position = local_pos
	highlight.set_owner(get_tree().edited_scene_root)
	return highlight
	
	
func emit_(S : Signal, data):
	print("SPECIAL EMIT FUNCTION CALLED ########################")
	S.emit(str(data), S.get_name())
	
func connect_debug_signal(s : Signal):
	pass
