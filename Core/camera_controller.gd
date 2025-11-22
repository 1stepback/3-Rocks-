extends Node3D

var player : Node3D
var sensitivity = 1.6


# sets relationship to player 
func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	
	$SpringArm3D.add_excluded_object(player)
	global_position = player.global_position

	

func _process(delta: float) -> void:
	global_position = player.global_position
	
	
func _input(event):
	if event is InputEventMouseMotion:
		
		var rot_x = rotation.x - event.relative.y/1000 * sensitivity * 4
		
		rotation.y -= event.relative.x/1000 * sensitivity * 4
		
		rot_x = clamp(rot_x, -1, 0.25)
		
		rotation.x = rot_x
