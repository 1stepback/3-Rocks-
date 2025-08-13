extends Node

class_name StateMachine

var state : String = "Idle"


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	get_node(state).physics_process(delta)
	


func change_state(new_state: String):
	
	get_node(state).exit_state()
	
	state = new_state
	
	get_parent().get_node("Label3D").text = new_state
	
	get_node(state).enter_state()
