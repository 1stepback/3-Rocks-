extends State

# used to stop jumping right after entering state 
var enter_timer_finished = false 

# used to stop entering the state after exiting it
var exit_timer_finished = true

func enter_state(): 
	$Timer_ledge_enter.start()
	
	await $Timer_ledge_enter.timeout
	# I can jump again 
	enter_timer_finished = true



func physics_process(delta):
	
	# exit to jump
	if Input.is_action_just_pressed("Jump"):
		# you can't jump right after entering the state 
		if enter_timer_finished:
			enter_timer_finished = false
			exit_timer_finished = false
			
			$Timer_ledge_enter.start()
			player.jump_check()
			
			
			await $Timer_ledge_enter.timeout
			# required to get back into LedgeGrab state
			exit_timer_finished = true
