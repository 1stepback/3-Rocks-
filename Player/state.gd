extends Node
class_name State

var player : Player
@onready var state_machine = get_parent()

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

func enter_protocol():
	pass

func exit_protocol():
	pass

func exit_to(new_state : String): 
	state_machine.change_state(new_state)

func physics_process( delta :float):
	pass
