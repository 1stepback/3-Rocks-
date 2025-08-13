extends State


func enter_state():
	player.AnimTreePlayback.travel("Idle")



func physics_process(delta): 
	
	player.jump_check()
	player.falling_check()
	
	var vec = player.gather_inputs()
	if vec:
		get_parent().change_state("Run")
		player.move_player(vec, delta)
		
		
