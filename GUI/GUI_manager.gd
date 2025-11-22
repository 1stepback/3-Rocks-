extends Control



##########    None of this is yet used 


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu"):
		$Menu.visible = !$Menu.visible
	
# set text
func set_dialogue_text(txt : String):
	$Dialogue/text.text = txt

# sets the dialogue character
func set_dialogue_character(img: ImageTexture):
	$Dialogue/char_icon.texture = img


# should recieve text, text placement info, optional icon
func set_game_message():
	pass
