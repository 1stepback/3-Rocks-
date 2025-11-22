extends CollisionShape3D


# I would like to connect: 
# detection on the player
# (for player only) Update GUI 
# update Player/NPC stats 
signal damage_taken(damage : int) # other arguments? 


@onready var Player_ref = get_parent()


func is_player_collision():
	pass
