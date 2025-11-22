@tool
extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Halo.rotate(Vector3.UP, delta)
	$Halo.position.y -= sin(Time.get_unix_time_from_system())/500
