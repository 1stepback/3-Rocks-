extends Node3D

var player : CharacterBody3D
var sensitivity = 1.6
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	global_position = player.global_position

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = player.global_position
	#print(global_position.length())
	
func _input(event):
	if event is InputEventMouseMotion:
		var rot_x = rotation.x - event.relative.y/1000 * sensitivity * 4
		rotation.y -= event.relative.x/1000 * sensitivity * 4
		
		rot_x = clamp(rot_x, -1, 0.25)
		
		rotation.x = rot_x
