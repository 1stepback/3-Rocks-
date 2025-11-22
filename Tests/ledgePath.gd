@tool
extends Path3D


@export var do_something = false :
	set(_nothing):
		print(EditorInterface.get_selection().get_selected_nodes())
