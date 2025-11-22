extends Note
class_name Sticky



# each buffer should hold the line/column information for 2
var buffers = []

# I want outside code to influence the buffers
# how do I hook in? 
@export var buffer_names : Array[String]
#@export_enum("one", "two", "three")var try2 : String

@onready var text_edit = $textMargin/components/TextEdit

func _ready() -> void:
	#Debug.collision.connect(set_buffer)
	find_buffers(0,0)
	#buffers.append(Vector2i(5,5))
	#text_edit.remove_text(0, 0, 5, 6)
	# for each buffer  // (vector2i)
	for b in buffers.size() :
		var buffer = buffers[b]
		var b_name = buffer_names[b]
		Debug.connect(b_name, Callable(self, "set_buffer") ) 
	
	#Debug.connect_debug_signal(Debug.collision)


func set_buffer(data:String, sig_name : String):
	print("MANAGED TO SET BUFFER")
	
func find_buffers(start_line, start_column):
	# argument is : (...line, column)
	# return is: Vector2i( column, line)

	var text_vector = text_edit.search("#", text_edit.SEARCH_WHOLE_WORDS, start_line, start_column )
	if text_vector.x != -1:
		print(text_vector)
		buffers.append(text_vector)
		
		text_edit.remove_text(start_line , start_column ,start_line  , start_column +1)
		
		return find_buffers(text_vector[1], text_vector[0] + 1) # theys stupidly reversed it
	else: 
		print("BUFFERS: " + str(buffers))
		return


func follow_mouse(offset = Vector2.ZERO):
	global_position = get_global_mouse_position() - offset
	#for pin :Pin in $Pin_container.get_children():
		#pin.snap_string()
	
var follow_obj
# add Shortcut moving here
func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("Left_click"):
		print("Left_click from: " + str(self.name))
		if Input.is_action_pressed("moveDebugPanel"):
			#print("MOVE PANEL")
			follow_obj = load("res://DebugStickyNotes/Sticky/FollowObject.tscn").instantiate()
			add_child(follow_obj)
			follow_obj.obj = self
			follow_obj.offset =  get_local_mouse_position() 
		
		
	if event.is_action_released("Left_click"):
		print("LEFT RELEASED")
		if follow_obj:
			follow_obj.queue_free()

	# replace this with just giving entire Event to Tool
										# if active_tool?
	#if event is InputEventMouseButton:
		#if !event.is_echo():
		
			
			# these action_just_pressed() functions  don't seem to work perfectly 
			# however they do work in combination with checking the event.is_pressed
			#if Input.is_action_just_pressed("left_click"):
				#if event.is_pressed():
					#
					#if Debug.active_tool:
						#Debug.active_tool.use_tool(self)
			#if Input.is_action_just_released("left_click"):
				#if event.is_released():
					#
					#if Debug.active_tool:
						#Debug.active_tool.end_tool_use()

# uses mouse position
#func get_nearest_side():
	#var ret_idx
	#var min_distance = INF
	#var mouse_offset
	#var parralel
	#for i in 4: 
		##var perpendicular = Debug.perpendicular_axis(i)
		##var mouse_local = get_local_mouse_position()
		##var side_offset = get_offset(i) 
		#
		## this computes the difference between local_mouse and relevant component of the edge 
		## bit complicated RN because get_offset() seems to include the position of Sticky relative Main 
		#var distance_to_edge = abs(  mouse_local[perpendicular]  - (side_offset - global_position[perpendicular]) )
		##if this edge is closer
		#if distance_to_edge < min_distance:
			#min_distance = distance_to_edge
			#ret_idx = i
			##parralel = 1 - perpendicular
			 #
			##mouse_offset = abs( mouse_local [parralel])
	#return ret_idx
	##add_pin(ret_idx, mouse_offset)
#
#func add_pin(side_idx: int, offset: float):
	#assert(side_idx < 4)
	#
	#var parralel = Debug.parralel_axis(side_idx)
	#var new_pin : Pin = pin_load.instantiate()
	#
	#
	#
	#var anch_preset = Debug.get_side_anchor_preset(side_idx)
	#
	## don't fuck with this function, it's somewhat necessary
	#new_pin.set_anchors_and_offsets_preset(anch_preset,  PRESET_MODE_KEEP_SIZE)#(anch_preset, PRESET_MODE_KEEP_SIZE)
#
	#new_pin.set_offset(parralel, offset)
	##add_active_string(new_pin)
	#$Pin_container.add_child(new_pin)
	#return new_pin
#
#func add_active_string(_pin : Pin):
	#var pin_pos = _pin.global_position
	#var new_string : noteString  = string_load.instantiate()
	#%stringBucket.add_child(new_string)
	#
	#_pin._string = new_string
	#_pin.snap_string()
	#new_string.set_point_active(1)
	#
	#return new_string

func get_handle(index) -> Handle:
	return $Handles.get_child(index)
	


	


func _on_focus_exited() -> void:
	print("FOCUS EXITED ############################################")
