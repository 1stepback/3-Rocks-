extends CharacterBody3D
class_name Player

const SPEED = 8.5
const JUMP_VELOCITY = 18
var camera_control :Node3D
var AnimTreePlayback

var ingredients = ["maybe start with most in restrcited?"]
# should be filled with the main objects, NOT collisionshapes
var interactables = []

var in_dialogue = false

var jumping_allowed = true

@onready var state_machine: StateMachine = $StateMachine
@onready var skin = $Armature/Skeleton3D/Ch39
@onready var floor_cast = $WallCast/FloorCast

func _ready() -> void:
	AnimTreePlayback = $AnimationTree.get("parameters/playback")
	camera_control = get_tree().get_nodes_in_group("Camera")[0]


func _process(delta: float) -> void:
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
	
	if Input.is_action_just_pressed("check_normals"):
		if floor_cast.is_colliding():
			var norm = floor_cast.get_collision_normal()
			var pos = floor_cast.get_collision_point()
			var norm_viewer  :RayCast3D = load("res://Debug/normal_viewer.tscn").instantiate()
			get_parent().add_child(norm_viewer)
			norm_viewer.position = pos
			norm_viewer.target_position = norm
			print(norm)
			
			


## Problem: Rays configured to be longer to account for sloped walls 
## will react further away on 90 walls 

## Fix: if 90 wall, make extra requirement to be < z amount away 

func ledge_detection() -> bool:
	var wall_ray: RayCast3D = $WallCast
	var ledge_ray : RayCast3D = $WallCast/LedgeCast
	if wall_ray.is_colliding():
		var wall_point = wall_ray.get_collision_point()
		var wall_normal = wall_ray.get_collision_normal()
		
		#var ledge_ray_offset =  Vector3(0, 0, 2.5)
		var wall_normal_y = wall_normal.y
	# Check that wall is vertical enough
		if wall_normal.y < 0.4:
			get_parent().get_node("WallLocator").global_position = wall_point
			var collision_rotated_local =  (wall_point - global_position).rotated(Vector3.UP, -global_rotation.y)
			var ray2_offset = collision_rotated_local.z + 0.12
			print(wall_normal.y)
			# for very vertical walls
			if abs(wall_normal.y) < 0.1:
				# if at tail end of wall_detection
				if ray2_offset > 0.5:
					return false
					
			ledge_ray.position.z = ray2_offset 
			ledge_ray.force_raycast_update()
			
			if ledge_ray.is_colliding():
				
				var ledge_normal = ledge_ray.get_collision_normal()
				var ledge_point = ledge_ray.get_collision_point()
				get_parent().get_node("LedgeLocator").global_position = ledge_point
				
				if ledge_normal.y > 0.85:
					
					AnimTreePlayback.travel("LedgeGrab")
					$StateMachine.change_state("LedgeGrab")
					return true
				
	return false






	#var input_vector = gather_inputs()
func falling_check():
	if not is_on_floor():
		$StateMachine.change_state("Fall")
		AnimTreePlayback.travel("Fall")
	


func jump_check():
	if jumping_allowed:
		if Input.is_action_just_pressed("Jump"):
			velocity.y = JUMP_VELOCITY
			# I just know this is bad practice
			move_and_slide()
			$StateMachine.change_state("Jump")

func apply_gravity( delta: float):
	
	if not is_on_floor():
	#	print("falling" + str(velocity))
		velocity += get_gravity() * delta


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
