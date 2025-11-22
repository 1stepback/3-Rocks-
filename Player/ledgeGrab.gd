extends State


var enter_timer_finished = false  # used to stop jumping right after entering state 
var exit_timer_finished = true  # used to stop entering the state after exiting it 

var player_pos
var player_quaternion

func enter_protocol(): 
	player.AnimTreePlayback.travel("LedgeGrab")
	player.show_hands_feet_locators(true)
	
	## will need to modify these again when I properly snap Player to Ledge!
	#player_pos = player.position
	#player_quaternion = player.quaternion

	$Timer_ledge_enter.start()
	await $Timer_ledge_enter.timeout
	enter_timer_finished = true   # I can jump again 


func exit_protocol():
	player.show_hands_feet_locators(false)
	var angle_to_vertical = player.basis.y.signed_angle_to(Vector3.UP, player.basis.x)
	player.basis = player.basis.rotated(player.basis.x, angle_to_vertical)

func physics_process(delta):
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






# didn't seem to do anything, was for debugging? 
#func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	#if anim_name == "LedgeGrab":
		#var root_motion =  player.get_node("AnimationTree").get_root_motion_position_accumulator()
		#var root_quaternion =  player.get_node("AnimationTree").get_root_motion_rotation()
		#
		
	
