extends AnimationTree





func _on_animation_finished(anim_name: StringName) -> void:
	if Debug.animations: 
		print("AnimTree: " + anim_name +  "  Finished")


func _on_animation_started(anim_name: StringName) -> void:
	if Debug.animations:
		print("AnimTree: " + anim_name +  "  Started")
