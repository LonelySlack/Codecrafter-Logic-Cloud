extends GraphNode

# Internal data
var input_color_name : String = ""
var output_a_name : String = ""
var output_b_name : String = ""

@onready var texture_rect = $TextureRect
# You need references to children 1 and 2 to make the slots appear visually correct
# (Assuming you have empty Labels or Control nodes as children 1 and 2)

func _ready():
	title = "Splitter"
	# Slot 0: Left Input enabled, Right Output disabled
	set_slot(0, true, 0, Color.WHITE, false, 0, Color.WHITE)
	
	# Slot 1: Left Input disabled, Right Output enabled
	set_slot(1, false, 0, Color.WHITE, true, 0, Color.WHITE)
	
	# Slot 2: Left Input disabled, Right Output enabled
	set_slot(2, false, 0, Color.WHITE, true, 0, Color.WHITE)

# ─────────────────────────────────────────────────────────────
# INPUT HANDLING
# ─────────────────────────────────────────────────────────────
func set_color_input(port: int, color_name: String):
	if port != 0: return
	input_color_name = color_name.to_lower()
	_process_split()

func clear_color_input(port: int):
	if port != 0: return
	input_color_name = ""
	output_a_name = ""
	output_b_name = ""
	_update_visual()

# ─────────────────────────────────────────────────────────────
# HELPER FOR GRAPH_EDIT
# ─────────────────────────────────────────────────────────────
func get_input_names() -> Array:
	# FIXED: GDScript uses 'if/else', not '?:'
	return [input_color_name] if input_color_name != "" else []

func is_split() -> bool:
	return true

# ─────────────────────────────────────────────────────────────
# LOGIC & VISUALS
# ─────────────────────────────────────────────────────────────
func _process_split():
	if input_color_name == "":
		_update_visual()
		return

	var result = ColorDatabase.split_color(input_color_name)

	if result.size() == 2:
		output_a_name = result[0]
		output_b_name = result[1]
	else:
		# Primary colors cannot split, so they just duplicate
		output_a_name = input_color_name
		output_b_name = input_color_name

	_update_visual()

func _update_visual():
	if output_a_name != "":
		var color_a = ColorDatabase.get_color_value(output_a_name)
		var color_b = ColorDatabase.get_color_value(output_b_name)
		var input_color = ColorDatabase.get_color_value(input_color_name)
		
		# Update Texture (show input color)
		if texture_rect:
			texture_rect.modulate = input_color
		
		# Update Slot Colors (Right side ports get the split colors)
		set_slot(1, false, 0, Color.WHITE, true, 0, color_a)
		set_slot(2, false, 0, Color.WHITE, true, 0, color_b)
		
		# Optional: Set text of child labels if they exist
		if get_child_count() > 1 and get_child(1) is Label:
			get_child(1).text = output_a_name
		if get_child_count() > 2 and get_child(2) is Label:
			get_child(2).text = output_b_name
			
	else:
		if texture_rect:
			texture_rect.modulate = Color.WHITE
		
		# Reset slots to white/empty
		set_slot(1, false, 0, Color.WHITE, true, 0, Color.WHITE)
		set_slot(2, false, 0, Color.WHITE, true, 0, Color.WHITE)
		
		if get_child_count() > 1 and get_child(1) is Label:
			get_child(1).text = ""
		if get_child_count() > 2 and get_child(2) is Label:
			get_child(2).text = ""
