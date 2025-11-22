extends CharacterBody3D
class_name Player

const SPEED = 8.5
@export var JUMP_VELOCITY :int
var health 

# state
var jumping_allowed = true




var ingredients = ["maybe start with most in restrcited?"]
# should be filled with the main objects, NOT collisionshapes
var interactables = []
var in_dialogue = false

var ledge_debug = []
var AnimTreePlayback
var camera_control :Node3D
@onready var state_machine: StateMachine = $StateMachine
@onready var skin = $Armature/Skeleton3D/Ch39
@onready var floor_cast = $WallCast/FloorCast
var portal

func _ready() -> void:
	AnimTreePlayback = $AnimationTree.get("parameters/playback")
	camera_control = get_tree().get_nodes_in_group("Camera")[0]


func show_hands_feet_locators(onOff):
	$feet_locator.visible = onOff
	$hand_locator.visible = onOff
	
func setup_ledge_locators():
	ledge_debug.append(load_highlight(Vector3.ZERO, get_parent(), Color.WHITE))
	ledge_debug.append(load_highlight(Vector3.ZERO, get_parent(), Color.WHITE))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("location_save"):
		# put this somewhere else? in the locator scene? in Main? 
		set_player_portal()
	
	if Input.is_action_just_pressed("Teleport"):
		global_position = portal.global_position
		

	if Input.is_action_just_pressed("Roll"):
		$StateMachine.change_state("Roll")
	
	if Input.is_action_just_pressed("Interact"):
		
		if interactables and not in_dialogue:
			in_dialogue = true
			var item : MeshInstance3D = interactables[0]
			# is it better to pass an array, or a reference to player, to access the array? 
			item.get_dialogue_data(ingredients)
			# I only want to turn the dialogue visible on first interaction, all other interact commands 
			# should only skip through the dialogue (handled by the dialogue node itself) 
			%Dialogue.visible  = !%Dialogue.visible
			# turn on process mode to allow dialogue to skip 
			%Dialogue.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# TOOL potential? 
	if Input.is_action_just_pressed("check_normals"):
		if floor_cast.is_colliding():
			var norm = floor_cast.get_collision_normal()
			var pos = floor_cast.get_collision_point()
			var norm_viewer  :RayCast3D = load("res://Debug/normal_viewer.tscn").instantiate()
			get_parent().add_child(norm_viewer)
			norm_viewer.position = pos
			norm_viewer.target_position = norm
			print("Floor Normal verticality is: " + str(norm.dot(Vector3.UP)))

func set_player_portal():
	portal = load("res://Debug/place_save.tscn").instantiate()
	get_parent().add_child(portal)
	portal.global_position = global_position
	
	
func gather_inputs(): 
	# this returns a Vector2!!!!!!
	
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	

	var direction :=  (Vector3( input_dir.x,  0,  input_dir.y )).normalized()
	direction = direction.rotated(Vector3.UP, camera_control.rotation.y )
	
	return direction
	

func move_player(vec: Vector3, delta):
	
	# change angle to look in the correct direction
	# this changes the angle of the main player, is that alright? 
	if vec:
		var a = Vector3.BACK.signed_angle_to(vec, Vector3.UP)
		var b = lerp_angle(rotation.y, a, 12 * delta)
		rotation.y = b
		
		#look_at(global_transform.origin - vec, Vector3.UP)
#
	if vec:
		velocity.x = vec.x * SPEED
		velocity.z = vec.z * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()



func apply_gravity( delta: float):
	
	if not is_on_floor():
	#	print("falling" + str(velocity))
		velocity += get_gravity() * delta


# fall state calls this, I want the state to handle the transition
# I need to return success or not
func ledge_detection() -> bool:
	
	# detect Ledge if above/in-front of player
	var coll_body = $ShapeCast3D.find_ledge_body()
	if coll_body: 
		# I still need to snap player to ledge
		var coll_point = $ShapeCast3D.get_collision_point(0)
		#load_highlight(coll_point, coll_body, Color.BLUE)
		ledge_debug[0].global_position = coll_point

		find_nearest_ledge(coll_body, coll_point)
		return true
	return false


# Successfully found Ledge
func find_nearest_ledge(collider :StaticBody3D, coll_point: Vector3):

	var mesh : climeable = collider.get_parent()
	
	var closest_point_on_edge :Vector3
	var closest_distance = INF
	var closest_edge 
	
	# Edge information could be useful here for snapping
	for edge in mesh.floor_outer_edges: # should be [ [vec3, vec3] ,  [vec3, vec3] .... 
		var edge_to_point_nearest = Geometry3D.get_closest_point_to_segment(coll_point, edge[0], edge[1])
		var distance = (edge_to_point_nearest - global_position).length()
		if distance < closest_distance:
			closest_distance = distance
			closest_point_on_edge = edge_to_point_nearest
			closest_edge = edge # can use index? Don't pre-optimise
	#Debug.emit_(Debug.collision, closest_edge )
	
	snap_Player_to_edge(closest_point_on_edge, closest_edge)
	# debug balls
	
	if Debug.edge_collisions:
		ledge_debug[1].global_position = closest_point_on_edge
		#load_highlight(closest_point_on_edge, mesh, Color.WHITE)
			

func snap_Player_to_edge( closest_point, closest_edge):
	print("snap_player_to_edge")
	var hand_offset : Vector3= %hand_locator.position.rotated(Vector3.UP, rotation.y)
	player_face_edge(closest_edge, closest_point)
	
	# place Player based on the Ledge point and the hand_locator
	global_position = closest_point - hand_offset
	
	$FeetCast.force_raycast_update()
	# FIND P2
	if $FeetCast.is_colliding():
		rotate_around_point(closest_point)
		
	
		
	#load_highlight()


# Rotates the player to face the ledge
func player_face_edge(edge :Array, edgePoint: Vector3):
	print("player_face_edge")
	var vec1 :Vector3= edge[0]
	var vec2 :Vector3= edge[1] 
	
	# local vector between 2 points
	var v = vec2 - vec1
	v.y = 0 # we don't want diagonal lines to tilt our character 
	
	# rotation is the angle compared to a fixed point in the horizontal plane
	# around the y-axis
	var rot = Vector3.BACK.signed_angle_to(v, Vector3.UP)
	# find out using some vector logic that I honestly barely understand.
	# I really need to review my vectors, and learn the more advanced stuff too
	var coef = clockwise_check(vec1 - global_position, vec2 - global_position)
	# go perpendicular to the angle of the edge (vertical difference excluded)
	# coefficient allows us to not care about which order the edge vertices are in. 
	# It means I technically don't have to sort my edges, end-to-end. But I think I probably will
	rotation.y = rot + (coef * PI/2)  #+ coef * PI/4



# rotate the player around a 3rd point
# uses Hand & Foot locator
func rotate_around_point(edgePoint):
	
		print("ROTATE AROUND POINT")
		
		var feet_collision_pt = $FeetCast.get_collision_point()
		var feet_collider = $FeetCast.get_collider()
		#load_highlight(feet_collision_pt, $FeetCast.get_collider(), Color.WHITE)
		
		# Vector we're rotating
		var hands_to_feet1 :Vector3 = $feet_locator.global_position - edgePoint
		
		# Vector we're rotating first vector to 
		var hands_to_collision :Vector3= feet_collision_pt - edgePoint
		
		# getting the axis of rotation ( frontflip/backflip here)
		var player_right = basis.x.normalized()
		
		# angle between 2 vectors
		var angle = hands_to_feet1.signed_angle_to(hands_to_collision, player_right)
		
		# rotated vector
		var P2 = hands_to_feet1.rotated(player_right, angle )
		
		# same angle? 
		var angle2 = hands_to_feet1.signed_angle_to(P2, player_right)
		
		var feet_locator_pos = $feet_locator.global_position - global_position
		var locator_rotated = feet_locator_pos.rotated(player_right, angle)
		global_position = edgePoint + P2 - locator_rotated
		
		var basis_x = basis.x
		basis = basis.rotated(basis_x, angle2) 
		


# uses cross product to determine if the vertices are in clockwise order or not
# if Clockwise, the first vertex will be left from the view of the player (origin)
# if Anti-Clockwise, the first vertex is right (and the second vertext left)
func clockwise_check(vec1, vec2):
	if vec2.cross(vec1).y > 0: 
		return 1
	else: return -1
	

func load_highlight(glob_pos: Vector3, highlight_parent, clr = Color.WHITE):
	
	var highlight : MeshInstance3D = load("res://Debug/highlight_ball.tscn").instantiate()
	if clr != Color.WHITE:
		#highlight.get_surface_override_material(0).make
		highlight.material_override.albedo_color = clr
	highlight_parent.add_child(highlight)
	highlight.global_position = glob_pos
	return highlight


func falling_check():
	if not is_on_floor():
		print("IS NOT ON FLOOR")
		$StateMachine.change_state("Fall")
		AnimTreePlayback.travel("Fall")



func jump_check():
	if jumping_allowed:
		if Input.is_action_just_pressed("Jump"):
			$StateMachine.change_state("Jump")
			return true
	return false
