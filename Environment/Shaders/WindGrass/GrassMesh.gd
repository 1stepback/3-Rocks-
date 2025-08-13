@tool
extends MultiMeshInstance3D

@export var reset_multimesh : bool :
	set(value):
		instance_grass()

@export var extents := Vector2.ONE
@export var spawn_outside_circle := false
@export var radius := 12.0

# unused code for collision ith grass / flower particles
#@export var character_path := NodePath()
#@onready var _character: Node3D = get_node(character_path)


#func _enter_tree() -> void:
	#visibility_changed.connect(_on_WindGrass_visibility_changed)

# every time the visibility is changed... 
#func _on_WindGrass_visibility_changed() -> void:
	#if visible:
		#print("resetting something")
		#_ready()

#func _process(_delta: float) -> void:
	#material_override.set_shader_parameter(
		#"character_position", _character.global_transform.origin
	#)

var last_grass_pos : Vector2


func instance_grass() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	var theta := 0
	var increase := 1
	var center: Vector3 = get_parent().global_transform.origin

	for instance_index in multimesh.instance_count:
		
		var transf := Transform3D().rotated(Vector3.UP, rng.randf_range(-PI / 2, PI / 2))
		var x: float
		var z: float
		
		if spawn_outside_circle:
			x = center.x + (radius + rng.randf_range(0, extents.x)) * cos(theta)
			z = center.z + (radius + rng.randf_range(0, extents.y)) * sin(theta)
			theta += increase
			
		# my use case
		
		else:
			if randf()>0.5: 
				x = rng.randf_range(-extents.x, extents.x)
				z = rng.randf_range(-extents.y, extents.y)
				last_grass_pos = Vector2(x,z)
			else: 
				print("adding blade of grass to previous position")
				x = last_grass_pos.x + randf() * 2 
				z = last_grass_pos.y + randf() * 2 
				
		
		
		transf.origin = Vector3(x, 0, z)

		multimesh.set_instance_transform(instance_index, transf)
