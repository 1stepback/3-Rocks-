@tool
extends RayCast3D

@export var button = false: 
	set(nuthin):
		thing()
	
	

func thing():
	global_position += Vector3(100, 100, 100)
	force_raycast_update()
	print("Is RayCast colliding? " + str(is_colliding()))
	global_position -= Vector3(100, 100, 100)
	force_raycast_update()
	print("Is RayCast colliding? " + str(is_colliding()))
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
