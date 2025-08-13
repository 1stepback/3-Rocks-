extends State



func enter_state():
	player.AnimTreePlayback.travel("Jump")



func physics_process(delta): 
	# not currently exiting a LedgeGrab
	if %LedgeGrab.exit_timer_finished == true:
		# ledge detect
		if player.ledge_detection():
			return
		
	player.apply_gravity(delta)
	
	var p_input = player.gather_inputs()
	player.move_player(p_input, delta)
	


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Jump": 
		get_parent().change_state("Fall")
		# AnimTree automatically handles animation change
