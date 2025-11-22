extends Control
class_name Handle

@export var side_idx : int
var PARRALEL :int
var PERPENDICULAR :int

var note : Panel
var active = false
var related_pins = []

var mouse_startingPos
var offset_save

func _ready() -> void:
	note = get_parent().get_parent()
	
	# setting axis using modulus trick provided by ChatGPT
	PERPENDICULAR = side_idx % 2
	PARRALEL = 1 - PERPENDICULAR
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		active = !active
		if event.is_pressed():
			setup_handle()
		
	if event is InputEventMouseMotion:
		if active: 
			move_handle()
#

func setup_handle():
	mouse_startingPos = get_global_mouse_position()
	offset_save = note.get_offset(side_idx)
	
func move_handle():
	
	var mouse_delta = get_global_mouse_position() - mouse_startingPos
			
	note.set_offset(side_idx, offset_save + mouse_delta[PERPENDICULAR] )
	sync_related_pins()
	


func sync_related_pins():
	for pin : Pin in related_pins:
		pin.snap_string()

func _on_resized() -> void:
	sync_related_pins()
