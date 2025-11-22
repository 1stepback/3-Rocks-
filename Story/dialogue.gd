extends Panel


var player
# set of lines to be run through
var lines = []
# index representing number of lines already displayed 
var index = 0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	player = get_tree().get_nodes_in_group("Player")[0]
	
func _process(delta: float) -> void:
	# in Dialogue node, this is used to set text and move index pointer to the next line
	# once i pass the number of lines, it should deactivate the dialogue 
	if Input.is_action_just_pressed("Interact"):
		print("interaction with Dialogue node captured")
		if index < lines.size():
			$text.text = lines[index]
			index += 1
		else: 
			print("deactivate dialogue")
			index = 0
			visible = false
			player.in_dialogue = false
			process_mode = Node.PROCESS_MODE_DISABLED
			
	
