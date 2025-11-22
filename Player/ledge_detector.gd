extends ShapeCast3D

# stops collision detection after initial collision 
var flag = true



# the main purpose of this function is to verify a valid ledge collision
# its called exclusively by FALL-STATE, leads to LEDGEGRAB-STATE transition
func find_ledge_body()  -> Object:
	
	# positive branch, collision found
	if is_colliding() and flag: 
		#print("COLLISION COUNT: " + str(get_collision_count()))
		for i in get_collision_count():
			var collider = get_collider(i)
			#if collider.is_in_group("climeable") :
			if collider.name == "FloorBody":
				flag = false
				return collider
	
	# negtive branch, no collision
	flag = true
	return null
