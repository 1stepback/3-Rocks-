extends Node
class_name State

var player : Player
var state_machine

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

func enter_state():
	pass

func exit_state(): 
	pass

func physics_process( delta :float):
	pass
