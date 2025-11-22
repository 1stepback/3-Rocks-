extends Node

class_name StateMachine

var state : String = "Idle"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#print("state:  " + str(state))
	get_node(state).physics_process(delta)
	#print(state)
	

func change_state(new_state: String):
	
	get_node(state).exit_protocol()
	
	state = new_state
	
	get_node(state).enter_protocol()
	
	get_parent().get_node("Label3D").text = new_state
