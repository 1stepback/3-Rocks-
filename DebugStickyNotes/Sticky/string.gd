extends Line2D
class_name noteString

var follow_mouse = load("res://Core/helpers/moveString/MoveString.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


var follow
func set_point_active(idx: int):
	follow = follow_mouse.instantiate()
	add_child(follow)
	follow.str = self
	follow.idx_move = idx

func stop_following():
	if follow:
		follow.free()
		
func snap_to_pin(pin):
	points[pin.index] = pin.global_position + pin.size/2
