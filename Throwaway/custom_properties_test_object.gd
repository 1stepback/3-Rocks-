extends Node3D

var test 

#
func _ready() -> void:
	print(get_child(0).mesh.get_meta("extras")) 
