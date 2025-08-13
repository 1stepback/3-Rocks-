extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_window().focus_exited.connect(on_window_focus_exited)

# when leaving window
func on_window_focus_exited():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$GUI.mouse_filter = Control.MOUSE_FILTER_STOP
	$GUI.release_focus()


func _input(event: InputEvent) -> void:
	
	# Pop-out mouse
	if Input.is_key_pressed(KEY_ESCAPE):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$GUI.release_focus()
		
		

# CAPTURE-MOUSE 
func _on_GUI_focus_entered() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
