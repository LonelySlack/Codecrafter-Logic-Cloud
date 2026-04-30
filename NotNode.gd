# ATTACH THIS SCRIPT TO: the root of your "NotNode.tscn" scene
extends GraphNode

# We store just one input value (0, 1, or -1 for empty)
var input_value: int = -1

# Store the visual output color
var output_color: Color = Color.TRANSPARENT

# Setup Assumption:
# Child 1: InputRow (Label) -> Slot 0
# Child 2: TextureRect (Triangle body) -> Slot 1 (Output)
func _ready():
	# Slot 0: Input (Left side enabled)
	set_slot(0, true, 0, Color.WHITE, false, 0, Color.WHITE)
	
	# Slot 1: Result (Right side enabled)
	set_slot(1, false, 0, Color.WHITE, true, 0, Color.WHITE)

# Called by GraphEdit when a connection is made
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

	# NOT Gate only accepts input on Port 0
	if port == 0:
		input_value = value
		set_slot(0, true, 0, color_value, false, 0, Color.WHITE)
	
	_update_logic()

# Called when disconnected
func clear_value_input(port: int):
	if port == 0:
		input_value = -1
		set_slot(0, true, 0, Color.WHITE, false, 0, Color.WHITE)
	_update_logic()

# This is where the NOT logic happens
func _update_logic():
	if input_value != -1:
		
		# --- LOGIC: INVERT THE SIGNAL ---
		var result = 0
		if input_value == 0:
			result = 1  # Black becomes White
		else:
			result = 0  # White becomes Black
		# --------------------------------
		
		if result == 1:
			output_color = Color.WHITE
		else:
			output_color = Color.BLACK
	else:
		output_color = Color.TRANSPARENT

	# Update the output slot color (Slot 1)
	set_slot(1, false, 0, Color.WHITE, true, 0, output_color)

# Return value for GraphEdit
func get_input_values() -> Array:
	return [input_value]
