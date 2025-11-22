extends Control


@export var corner_sides : PackedInt32Array
var active = false


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		active = !active
		if event.is_pressed():
			
			for side in corner_sides:
				
				get_parent().get_child(side).setup_handle()
		
	if event is InputEventMouseMotion:
		if active: 
			for side in corner_sides:
				get_parent().get_child(side).move_handle()
#
