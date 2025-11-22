extends MeshInstance3D

# depending on size of image, will depend size of textbox 
@onready var dialogue_icon = load("res://icon.svg")
@onready var dialogue_text = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_dialogue_data(player_ingredients): 
	$StoryObject.check_ingredients(player_ingredients)
	
func _on_area_3d_body_entered(body: Player) -> void:
	if body.is_in_group("Player"):
		body.interactables.append(self)


func _on_area_3d_body_exited(body: Player) -> void:
	if body.is_in_group("Player"):
		body.interactables.erase(self)


	
