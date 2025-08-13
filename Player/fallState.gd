extends State






func physics_process(delta):
	if %LedgeGrab.exit_timer_finished == true:
		if player.ledge_detection():
			return
		
	player.apply_gravity(delta)
	
	var p_input = player.gather_inputs()
	# Landed
	if player.is_on_floor(): 
		
		if p_input: 
			get_parent().change_state("Run")
		else: 
			get_parent().change_state("Idle")
	else:
		
		player.move_player(p_input, delta)
