extends State

func enter_protocol():
	player.AnimTreePlayback.travel("Fall")

func physics_process(delta):
	if %LedgeGrab.exit_timer_finished == true:
		if player.ledge_detection():
			
			#player.global_position = ret - %hand_locator.position # HELLA BAND-AID!!!
			exit_to("LedgeGrab")
			return
	
	player.apply_gravity(delta)
	var p_input = player.gather_inputs()
	
	# Landed
	if player.is_on_floor(): 
		if p_input: 
			exit_to("Run")
		else: 
			exit_to("Idle")
	else:
		
		player.move_player(p_input, delta)
