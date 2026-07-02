@tool
extends MeshInstance3D
class_name climeable

var meshSplicer = preload("res://Core/meshSplicer.gd")

@export var sorted_Ledges= []

@export var splice_button = false : 
	set(_b):
		splice_mesh()


# should I store references to all 4 collision based nodes here?
# or keep scope within the function? By returning data from set_up_collision_nodes()
#var wall_body
#var floor_body
#var wall_coll_shape
#var floor_coll_shape


func splice_mesh():
	
	# sets up Collision Shapes if not already 
	# should this 
	var collision_node_data = set_up_collision_nodes()
	var floor_coll_node = collision_node_data[3]
	var wall_coll_node = collision_node_data[2]

	var splicer = meshSplicer.new()
	var splice_data = splicer.use_tool(self)  # 3 item array [mesh, mesh, sorted_Ledges]
	var floor_mesh = splice_data[0]
	var wall_mesh = splice_data[1]

	add_mesh_to_collision(floor_coll_node, floor_mesh)
	add_mesh_to_collision(wall_coll_node, wall_mesh)
	
	#var test_single_edges  = data[3]
	#create_ledge_paths(test_single_edges)
	
	sorted_Ledges = splice_data[2]
	create_ledge_paths(sorted_Ledges)
	
	splicer = null


func set_up_node_inEditor(_name : String, initialized : Node, parent: Node, sceneroot):
	var ret
	# check parent to allow this to work for sub-children
	if parent.has_node(_name):
		ret = parent.get_node(_name)
	else: 
		ret = initialized
		ret.name = _name
		parent.add_child(ret)
		ret.owner = sceneroot
	return ret


func set_up_collision_nodes():

	var scene_root := get_tree().edited_scene_root
	
	# currently only sets up internal variables (currently necessary) if not already set up
	var wall_body = set_up_node_inEditor("WallBody", StaticBody3D.new(), self, scene_root)
	var floor_body = set_up_node_inEditor("FloorBody", StaticBody3D.new(), self, scene_root)
	var wall_coll_shape = set_up_node_inEditor("WallCollShape", CollisionShape3D.new(), wall_body, scene_root)
	var floor_coll_shape = set_up_node_inEditor("FloorCollShape", CollisionShape3D.new(), floor_body, scene_root)
	
	return [wall_body, floor_body, wall_coll_shape, floor_coll_shape]
	


# creates a Path3D
func create_ledge_paths(sorted_Ledges: Array):
	var scene_root := get_tree().edited_scene_root
	
	# I would like to create persistance in Ledge Paths
	# when splice data is acquired (ie: here) 
	# check its indices against the current set of Paths (if they exist) 
	# current paths should be stored in something other than an array
	# because order in arrays not stable (dictionary?) 
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

# simplified from function to set up collision nodes
#if has_node("WallBody"):
		#wall_body = get_node("WallBody")
	#
	#else:
		#wall_body = StaticBody3D.new()
		#wall_body.name = "WallBody"
		#add_child(wall_body)
		#wall_body.owner = scene_root
	#
	#
	#if not has_node("FloorBody"):
		#floor_body = StaticBody3D.new()
		#floor_body.name = "FloorBody"
		#add_child(floor_body)
		#floor_body.owner = scene_root
	#
	#if not has_node("WallBody/WallCollShape"):
		#wall_coll_shape = CollisionShape3D.new()
		#wall_coll_shape.name = "WallCollShape"
		#wall_body.add_child(wall_coll_shape)
		#wall_coll_shape.owner = scene_root
	#
	#if not has_node("FloorBody/FloorCollShape"):
		#floor_coll_shape = CollisionShape3D.new()
		#floor_coll_shape.name = "FloorCollShape"
		#floor_body.add_child(floor_coll_shape)
		#floor_coll_shape.owner = scene_root



# rebuild collision mesh from my Floor & Wall (not floor) arrays
#func build_collision_from_spliced_mesh( floor_mesh, wall_mesh, wall_coll_shape, floor_coll_shape):
	#
	##var WallCollShape = wall_coll_shape #$WallBody/CollisionShape3D
	##var FloorCollShape = floor_coll_shape #$FloorBody/CollisionShape3D
	#
	## these are set by the inital function, the first time it's used (if non-existant already)
	#add_mesh_to_collision(wall_coll_shape, wall_mesh)
	#add_mesh_to_collision(floor_coll_shape, floor_mesh)
	#
