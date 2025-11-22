extends Node3D

var normals_checker = load("res://Core/NormalsVisualizer.tres")
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:#
	#recursive_add_normals_theme(self)

#func recursive_add_normals_theme(node):
	#for child :Node3D in get_children(): 
		#if child.name == "WallBody" or child.name != "CollisionShape" or child.name != "FloorBody":
			#return
		#else:
			#child.material_override = normals_checker
		#recursive_add_normals_theme(child)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
