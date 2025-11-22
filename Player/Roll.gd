extends State



func enter_protocol():
	player.AnimTreePlayback.travel("Roll")

func physics_process(delta):

	var currentRotation = player.transform.basis.get_rotation_quaternion()
	var root_motion =  player.get_node("AnimationTree").get_root_motion_position()
	print(root_motion)
	var velocity = (currentRotation.normalized() * root_motion) #/ delta
	player.velocity  = velocity
	player.move_and_slide()


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Roll":
		var p_input = player.gather_inputs()
		if player.jump_check():
			pass
		elif p_input:
			player.get_node("StateMachine").change_state("Run")
		else: 
			player.get_node("StateMachine").change_state("Idle")
