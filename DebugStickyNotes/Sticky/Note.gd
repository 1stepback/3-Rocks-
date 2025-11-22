extends Panel
class_name Note




func _on_mouse_entered() -> void:
	Debug.moused_debug_panel = self


func _on_mouse_exited() -> void:
	assert (Debug.moused_debug_panel == self)
	Debug.moused_debug_panel = null
