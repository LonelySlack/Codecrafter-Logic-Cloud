# OrNode.gd
# ATTACH THIS SCRIPT TO: the root of your "OrNode.tscn" scene
extends GraphNode

# We'll store the binary values (0, 1, or -1 for empty)
var input_a_value: int = -1
var input_b_value: int = -1

# Store the visual output color
var output_color: Color = Color.TRANSPARENT

# It assumes your scene has 3 children, in order:
# 1. InputRow1 (Label)
# 2. InputRow2 (Label)
# 3. TextureRect (The main purple body)
func _ready():
	# Slot 0: Input A (Left)
	set_slot(0, true, 0, Color.WHITE, false, 0, Color.WHITE)
	# Slot 1: Input B (Left)
	set_slot(1, true, 0, Color.WHITE, false, 0, Color.WHITE)
	# Slot 2: Result (Right)
	set_slot(2, false, 0, Color.WHITE, true, 0, Color.WHITE)

# This function will be called by the GraphEdit
func set_value_input(port: int, color_name: String):
	var value: int = -1
	var color_value: Color = Color.TRANSPARENT

	match color_name.to_lower():
		"white":
			value = 1
			color_value = Color.WHITE
		"black":
			value = 0
			color_value = Color.BLACK

	if port == 0:
		input_a_value = value
		set_slot(0, true, 0, color_value, false, 0, Color.WHITE)
	elif port == 1:
		input_b_value = value
		set_slot(1, true, 0, color_value, false, 0, Color.WHITE)
	
	_update_logic()

func clear_value_input(port: int):
	if port == 0:
		input_a_value = -1
		set_slot(0, true, 0, Color.WHITE, false, 0, Color.WHITE)
	elif port == 1:
		input_b_value = -1
		set_slot(1, true, 0, Color.WHITE, false, 0, Color.WHITE)
	_update_logic()

# This is where the OR logic happens
func _update_logic():
	if input_a_value != -1 and input_b_value != -1:
		
		# --- THIS IS THE CHANGE ---
		# Perform bitwise OR
		var result = input_a_value | input_b_value
		# --------------------------
		
		if result == 1:
			output_color = Color.WHITE
		else:
			output_color = Color.BLACK
	else:
		output_color = Color.TRANSPARENT

	set_slot(2, false, 0, Color.WHITE, true, 0, output_color)

# Return values for GraphEdit to read
func get_input_values() -> Array:
	return [input_a_value, input_b_value]
