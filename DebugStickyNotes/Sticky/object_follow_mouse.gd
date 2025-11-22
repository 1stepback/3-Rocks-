extends Node



# things that might use this:
# Notes
# Ghosts 
# strings/pins 

# but maybe this cant be a one-size-fits-all solution



var obj : CanvasItem
var offset : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	obj.follow_mouse(offset)
