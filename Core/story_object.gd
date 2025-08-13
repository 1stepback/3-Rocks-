extends Node

# put in inherited class? 
func check_ingredients(player_ingredients):
	for ingredient in active_ingredients:
		if player_ingredients.has(ingredient):
			active_ingredients[ingredient].call()


#########################################################################
var active_ingredients = {
	"maybe start with most in restrcited?" : beginner_tutorial
}

var consumed_ingredients = {
	"defeated boss1" : defeated_boss1
}
var restricted_ingredients = {
	"conquered grandline": on_conquered_grand_line
}
########################################################################
var lines 

func beginner_tutorial():
	var temp = load("res://Story/dialogue_test.gd").new()
	# wrap this in a dialogue changing function 
	# use signal? 
	%Dialogue.lines = temp.lines


func on_conquered_grand_line():
	print("conquered GRANDLINE")
	
	
func defeated_boss1():
	print("Defeated boss1")
