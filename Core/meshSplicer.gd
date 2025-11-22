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
func use_tool(meshInstance):
	Tools.display_tool_use()
	
	var err = create_from_surface(meshInstance.mesh, 0)

	test_edge_face_count()
	var wall_faces = []
	var floor_faces = []
	var counter = 0
	var total_edge_counter = 0
	# for each face
	for f in range(get_face_count()):
		
		var tri = []
		for v in 3:
			
			var v_index := get_face_vertex(f, v) 
			var v_pos:= get_vertex(v_index)
			tri.append(v_pos)
		
		# define FLOOR or WALL
		# Here I could try and use vertex-normals if I want to handle Smoothed geometry 
		var normal = get_face_normal(f)
		var verticality = normal.dot(Vector3.UP)
		
		#FLOOR
		if verticality > 0.85:
			counter += 1
			floor_faces.append(tri)
		
			# 3 edges composed of 2 Vector3s
			#var glob_tri_edges = get_global_tri_edges(tri, meshInstance)
			var local_tri_edges = get_local_tri_edges(tri, meshInstance)
			filter_outer_edges(local_tri_edges)
		
		## NOT FLOOR (INCLUDES RED-FACES)
		if verticality < 0.85:
			wall_faces.append(tri)
	
	var wall_mesh = build_mesh_from_triangles(wall_faces)
	var floor_mesh = build_mesh_from_triangles(floor_faces)
	
	
	sort_edges(floor_outer_edges)
	
	#return [floor_mesh, wall_mesh, floor_outer_edges]
	return [floor_mesh, wall_mesh, floor_outer_edges,sorted_Ledges]


# [ [ seg1, seg2, seg3, seg4], [seg1, seg2...]]    segments are Array[Vector3, vector3]
var sorted_Ledges = [[]]
var sorted_idx = 0

# take a group of unsorted edges, and outputs an array of 1 or several Ledge-Paths [[LedgePath], [LedgePath2]...]
# for use in creating Path3D's 
func sort_edges(unsorted_edges :Array):
	# start from arbitrary edge  ( & remove from checked list)    happens 1x
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
			
			
# I can definitely remove this from the process of splicing, and put it after the fact
# it only needs to take in Tris, and have access to the original mesh node
func get_global_tri_edges(tri, meshInstance):
	var glob_tri = []
	for vert in tri:
		glob_tri.append(meshInstance.to_global(vert))
			# 3 edges composed of 2 Vector3s
	return [ [ glob_tri[0], glob_tri[1] ] ,  [ glob_tri[1],glob_tri[2] ] ,  [ glob_tri[2],glob_tri[0] ]  ]

# pisstake of the function above, fix this right away 
func get_local_tri_edges(tri, meshInstance):
	var glob_tri = []
	for vert in tri:
		glob_tri.append(vert)
			# 3 edges composed of 2 Vector3s
	return [ [ glob_tri[0], glob_tri[1] ] ,  [ glob_tri[1],glob_tri[2] ] ,  [ glob_tri[2],glob_tri[0] ]  ]

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
