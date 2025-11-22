extends Panel
class_name Pin

var _sticky : Sticky
var _string : noteString
var index

func set_anchor_wrapper(anch_preset):
	set_anchors_preset(anch_preset)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func snap_string():
	if _string:
		_string.snap_to_pin(self)
