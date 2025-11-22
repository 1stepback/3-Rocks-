extends Node

# an interface that the main codebase references when performing debug operations 
var edge_collisions = false
var animations = false

signal collision()
var moused_debug_panel = null

func emit_(S : Signal, data):
	print("SPECIAL EMIT FUNCTION CALLED ########################")
	S.emit(str(data), S.get_name())
	
func connect_debug_signal(s : Signal):
	pass
