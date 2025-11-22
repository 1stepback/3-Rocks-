extends State




func enter_protocol():
	player.AnimTreePlayback.travel("Run")



func physics_process(delta): 
	# check inputs
	if not player.jump_check():
		player.falling_check()

	
	var input_vector = player.gather_inputs()
	if input_vector: 
		player.move_player(input_vector, delta)
		player.apply_gravity(delta)
		
	else:
		get_parent().change_state("Idle")
		
		
