@tool
extends MeshDataTool


var floor_outer_edges = []




func test_edge_face_count():
	var count_ones = 0
	var count_twos = 0
	for edge in get_edge_count():
		var how_many_faces = get_edge_faces(edge).size()
		if how_many_faces == 1: 
			count_ones +=1
		else: 
			count_twos += 1
			
	print("object has  " + str(count_ones) + "  edges with 1 face")
	print("and  " + str(count_twos) + "  edges with 2 face")

# This only works with ArrayMeshes, doesn't work with primitive shapes
func use_tool(meshInstance : MeshInstance3D):
	Tools.display_tool_use()
	
	var error = create_from_surface(meshInstance.mesh, 0)
	assert(error == OK)

	test_edge_face_count()
	var wall_faces = []
	var floor_faces = []
	var counter = 0
	var total_edge_counter = 0
	# for each face
	for f in range(get_face_count()):
		
		var tri = []
		for v in 3:
			#print(get_face_edge(f, v))
			var v_index := get_face_vertex(f, v) 
			var v_pos:= get_vertex(v_index)
			tri.append(v_pos)
			
			var test_edge = get_face_edge(f, v)
		
		# define FLOOR or WALL
		# Here I could try and use vertex-normals if I want to handle Smoothed geometry 
		var perpend = meshInstance.basis.y.cross(Vector3.UP)
		var angle = meshInstance.basis.y.signed_angle_to(Vector3.UP, perpend)
		var normal = get_face_normal(f).rotated(perpend.normalized(), angle)
		var verticality = normal.dot(Vector3.UP)
		
		#FLOOR
		if verticality > 0.85:
			counter += 1
			floor_faces.append(tri)
		
			# HERE: we decide to send tri off for edge sorting?  
			# use get_face_edges here
			for e in 3:
				var edge_idx = get_face_edge(f, e)
				filter_outer_edges2(edge_idx)
			
			#var local_tri_edges = get_local_tri_edges(tri, meshInstance)
			#filter_outer_edges(local_tri_edges)
		
		## NOT FLOOR (INCLUDES RED-FACES)
		if verticality < 0.85:
			wall_faces.append(tri)
	
	
	
	var wall_mesh = build_mesh_from_triangles(wall_faces)
	var floor_mesh = build_mesh_from_triangles(floor_faces)
	
	build_edges_from_indices()
	sort_edges(floor_outer_edges)
	#debug_single_edges(ledge_single_edges, meshInstance)
	
	
	# I don't exactly remember what I was thinking here
	#meshInstance.mesh.clear_surfaces()
	#commit_to_surface(meshInstance.mesh)


	#return [floor_mesh, wall_mesh, floor_outer_edges]
	return [floor_mesh, wall_mesh, sorted_Ledges] #ledge_single_edges]


func debug_single_edges(single_edges: Array, meshInstance):
	print("SINGLE SIZE ... TEST= " + str(single_edges.size()))
	for edge in single_edges:
		var in_btwn = (edge[0] + edge[1])/2
		Debug.load_highlight(in_btwn, meshInstance) 
	
var ledge_single_edges = []
var ledge_double_edges = []
func build_edges_from_indices():
	
	for e in floor_edge_indices:
		var edge = []
		for i in 2:
			var v = get_edge_vertex(e, i)
			edge.append(get_vertex(v))
	
		floor_outer_edges.append(edge)
		
		if get_edge_faces(e).size() < 2:
			ledge_single_edges.append(edge)
		else:
			ledge_double_edges.append(edge)
			
	print("LEDGE_SINGLE_EDGES.size IS: " + str(ledge_single_edges.size()))
	print("LEDGE_DOUBLE_EDGES.size IS: " + str(ledge_double_edges.size()))

			
			
func test_move_points(edge_idx):
	for i in 2:
		var v_idx = get_edge_vertex(edge_idx, i)
		var v_pos = get_vertex(v_idx)
		set_vertex(v_idx, v_pos + Vector3(0, 0.08, 0))


# [ [ seg1, seg2, seg3, seg4], [seg1, seg2...]]    segments are Array[Vector3, vector3]
var sorted_Ledges = [[]]
var sorted_idx = 0

# take a group of unsorted edges, and outputs an array of 1 or several Ledge-Paths [[LedgePath], [LedgePath2]...]
# for use in creating Path3D's 
func sort_edges(unsorted_edges :Array):
	assert(unsorted_edges)
	var start_edge = unsorted_edges.pop_front()
	sorted_Ledges = [[start_edge]]
	
	find_next_edge(start_edge, unsorted_edges )


func find_next_edge(currentEdge, unsorted_edges: Array):
	# this finds the edge that comes next (with vertices ordered correctly)
	# take 2nd vertex (also arbitrary?) 
	var comparaison_point :Vector3 = currentEdge[1]
	for edge :Array in unsorted_edges:
		# check if one of the edges vertices matches 
		for i in 2: 
			
			# found next point
			if edge[i].is_equal_approx(comparaison_point):
				
				# this breaks loop indices
				unsorted_edges.erase(edge)                # remove edge from pool 
				#flip if first vertex matches (to sync with arbitary order) 
				if i == 1:
					edge.reverse()
				
				var temp_edge = edge
				# add to sorted loops
				sorted_Ledges[sorted_idx].append(edge)
				
				var first_vertex = sorted_Ledges[sorted_idx][0][0]
				
				# still edges left to sort
				if unsorted_edges:
					var next_edge 
					# got to the end of a loop
					if edge[1].is_equal_approx(first_vertex) :
						# edges will be added to a new loop
						sorted_idx += 1
						# create new container to match new index
						sorted_Ledges.append([])
						next_edge = unsorted_edges[0]
					
					# continuing a Ledge
					else:
						next_edge = edge
					
					# start loop aknew
					find_next_edge(next_edge, unsorted_edges)
					
				# no more un-sorted Edges
				else: 
					return


func filter_outer_edges(tri_edges):
# if an edge appears 2x, remove it 
# this finds all the outer edges (which appear 1x) 
	for edge: Array in tri_edges:
		#total_edge_counter +=1
		edge.reverse()  # currently necessary,identical edges are probably mirrored identical edges are probably mirrored
		if floor_outer_edges.has(edge):
			floor_outer_edges.erase(edge)
		else:
			edge.reverse()
			floor_outer_edges.append(edge)

var floor_edge_indices = []
func filter_outer_edges2(edge_idx):
	#edge.reverse()  # currently necessary,identical edges are probably mirrored identical edges are probably mirrored
	if floor_edge_indices.has(edge_idx):
		#print("Ledge data discriminated correctly")
		floor_edge_indices.erase(edge_idx)
	else:
		#edge.reverse()
		floor_edge_indices.append(edge_idx)
			
# I can definitely remove this from the process of splicing, and put it after the fact
# it only needs to take in Tris, and have access to the original mesh node
func get_local_tri_edges(tri, meshInstance):
	var local_tri = []
	for vert in tri:
		local_tri.append(vert)
			# 3 edges composed of 2 Vector3s
	return [ [ local_tri[0], local_tri[1] ] ,  [ local_tri[1],local_tri[2] ] ,  [ local_tri[2],local_tri[0] ]  ]

# mostly chatGPT
# Rebuilds an ArrayMesh from a list of triangles.
# Each triangle is a list of 3 Vector3s: [v0, v1, v2]
func build_mesh_from_triangles(triangles: Array) -> Mesh:
	var vertices := PackedVector3Array()  # Stores all vertex positions
	var indices := PackedInt32Array()     # Stores the order to draw triangles

	# Loop over every triangle (3 Vector3 points)
	for tri in triangles:
		var start_index := vertices.size()  # Index where this triangle starts in the vertex array

		# Add each point of the triangle as a new vertex
		for vertex in tri:
			vertices.append(vertex)

		# Add indices for this triangle (drawn in the order we added)
		indices.append_array([start_index, start_index + 1, start_index + 2])

	# Godot's mesh system uses an array of arrays for different attributes
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)  # Max number of attribute slots (position, normal, etc.)

	arrays[Mesh.ARRAY_VERTEX] = vertices  # Provide vertex positions
	arrays[Mesh.ARRAY_INDEX] = indices    # Provide triangle draw order

	# Create a new mesh and assign the vertex/index data as a surface
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	return mesh
