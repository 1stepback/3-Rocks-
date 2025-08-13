extends State




func enter_state():
	player.AnimTreePlayback.travel("Run")



func physics_process(delta): 
	# check inputs
	player.jump_check()
	player.falling_check()

	
	var input_vector = player.gather_inputs()
	if input_vector: 
		player.move_player(input_vector, delta)
		player.apply_gravity(delta)
		
	else:
		get_parent().change_state("Idle")
		
		
