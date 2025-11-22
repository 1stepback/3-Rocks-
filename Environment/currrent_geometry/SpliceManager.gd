@tool
extends Node3D

@export var splice :bool :
	set(b):
		call_splices()

@export var show_normals = false : 
	set(v):
		show_normals = v 
		for child :MeshInstance3D in get_children():
			if v: 
				child.set_surface_override_material(0, load("res://Core/NormalsVisualizer.tres"))
			else: 
				child.set_surface_override_material(0, null)
				


func call_splices():
	for child in get_children():
		print(child.name)
		if not child.get_script() :
			child.set_script(load("res://Core/meshClimeable.gd"))
		child.splice_mesh()
