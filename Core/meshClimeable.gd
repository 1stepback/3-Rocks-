@tool
extends MeshInstance3D
class_name climeable

var meshSplicer = preload("res://Core/meshSplicer.gd")

@export var floor_outer_edges = []

@export var splice_button = false : 
	set(_b):
		splice_mesh()



var wall_body
var floor_body
var wall_coll_shape
var floor_coll_shape


func splice_mesh():
	
	# sets up if not already existing
	set_up_collision_nodes()

	var splice = meshSplicer.new()
	var data = splice.use_tool(self)  # 3 item array [mesh, mesh, global_edges]
	
	build_collision_from_spliced_mesh(data[0], data[1])
	floor_outer_edges = data[2]
	var sorted_Ledges = data[3]
	#print("sorted_Ledges: " + str(sorted_Ledges))
	create_ledge_paths(sorted_Ledges)
	splice = null



func set_up_collision_nodes():

	var scene_root := get_tree().edited_scene_root
	
	# If 
	if not has_node("WallBody"):
		wall_body = StaticBody3D.new()
		wall_body.name = "WallBody"
		add_child(wall_body)
		wall_body.owner = scene_root
	
	if not has_node("FloorBody"):
		floor_body = StaticBody3D.new()
		floor_body.name = "FloorBody"
		add_child(floor_body)
		floor_body.owner = scene_root
	
	if not has_node("WallBody/WallCollShape"):
		wall_coll_shape = CollisionShape3D.new()
		wall_coll_shape.name = "WallCollShape"
		wall_body.add_child(wall_coll_shape)
		wall_coll_shape.owner = scene_root
	
	if not has_node("FloorBody/FloorCollShape"):
		floor_coll_shape = CollisionShape3D.new()
		floor_coll_shape.name = "FloorCollShape"
		floor_body.add_child(floor_coll_shape)
		floor_coll_shape.owner = scene_root


# creates a Path3D
func create_ledge_paths(sorted_Ledges: Array):
	var scene_root := get_tree().edited_scene_root
	for Ledge in sorted_Ledges:
		#print("Ledge data is: " + str(Ledge))
		var path = Path3D.new()
		var curve = Curve3D.new()
		curve.closed = true
		add_child(path)
		path.set_owner(scene_root)
		for edge in Ledge:
			curve.add_point(edge[0])
		path.curve = curve


# rebuild collision mesh from my Floor & Wall (not floor) arrays
func build_collision_from_spliced_mesh( floor_mesh, wall_mesh):
	
	#var WallCollShape = wall_coll_shape #$WallBody/CollisionShape3D
	#var FloorCollShape = floor_coll_shape #$FloorBody/CollisionShape3D
	
	# these are set by the inital function, the first time it's used (if non-existant already)
	add_mesh_to_collision(wall_coll_shape, wall_mesh)
	add_mesh_to_collision(floor_coll_shape, floor_mesh)
	

# mostly chatGPT, look-over ASAP
# pair a mesh with a collision shape using correct data format
func add_mesh_to_collision(collision_shape: CollisionShape3D, array_mesh: ArrayMesh):
	if array_mesh.get_surface_count() == 0:
		push_error("Mesh has no surfaces")
		return

	var arrays := array_mesh.surface_get_arrays(0)
	var vertices = arrays[Mesh.ARRAY_VERTEX]

	var shape := ConcavePolygonShape3D.new()
	shape.data = vertices  # Assign raw triangle data (flat list of points)
	collision_shape.shape = shape
