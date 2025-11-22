extends Node3D


func _ready() -> void:
	for i in 2: 
			print(i)
	Debug.edge_collisions = true
	$Character.set_player_portal()
	$Character.setup_ledge_locators()
