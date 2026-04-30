extends TextureRect

# --- SIGNALS ---
signal puzzle_solved
var is_finished = false

# This determines what this bucket accepts (e.g., "integer", "string", "int_array")
@export var required_type: String = "integer":
	set(new_value):
		required_type = new_value
		_update_label_display(null)

func _ready():
	_update_label_display(null)

func _can_drop_data(_at_position, data):
	return data is Dictionary and data.has("type")

func _drop_data(_at_position, data):
	# CHECK: Is the type correct?
	if data["type"] == required_type:
		# --- CORRECT DROP ---
		
		# Log Success to Manager
		if owner.has_method("update_log"):
			var msg = "Initialized " + required_type + " with value: " + str(data["value"])
			owner.update_log(msg, false)
			
		_update_label_display(data["value"])
		
		# Green Flash
		modulate = Color.GREEN
		await get_tree().create_timer(0.5).timeout
		modulate = Color.WHITE
		
		# Mark as solved
		if not is_finished:
			is_finished = true
			puzzle_solved.emit() 
			
	else:
		# --- WRONG DROP ---
		
		# Log Error to Manager
		if owner.has_method("update_log"):
			var msg = "Cannot assign type '" + data["type"] + "' to " + required_type
			owner.update_log(msg, true)
		
		# Red Flash
		modulate = Color.RED
		await get_tree().create_timer(0.5).timeout
		modulate = Color.WHITE

# --- DISPLAY UPDATE LOGIC (FIXED) ---
func _update_label_display(display_value):
	var label_node = get_node_or_null("Label")
	if not label_node: return
	
	# 1. CLEAN UP THE TYPE NAME (Convert "int_array" -> "int[]")
	var display_type = required_type
	if required_type.ends_with("_array"):
		var base = required_type.replace("_array", "")
		if base == "string": base = "String" # Capitalize String
		display_type = base + "[]"
	elif required_type == "string":
		display_type = "String"
	
	# 2. EMPTY STATE (Waiting for input)
	if display_value == null:
		var var_name = "list" if required_type.ends_with("_array") else "x"
		if required_type == "string": var_name = "s"
		if required_type == "boolean": var_name = "b"
		
		label_node.text = display_type + " " + var_name + " = ?;"
		return
	
	# 3. FILLED STATE (Formatting the value)
	var val_str = str(display_value)
	
	# --- ARRAY LOGIC (Level 3) ---
	if required_type.ends_with("_array"):
		# We need to split "1, 2, 3" and add quotes/brackets
		var items = val_str.split(",")
		var formatted_items = []
		
		for item in items:
			var clean_item = item.strip_edges()
			# Add quotes for String or Char arrays
			if "string" in required_type:
				clean_item = '"' + clean_item + '"'
			elif "char" in required_type:
				clean_item = "'" + clean_item + "'"
			
			formatted_items.append(clean_item)
		
		# Join them back with brackets!
		val_str = "{" + ", ".join(formatted_items) + "}"
		label_node.text = display_type + " list = " + val_str + ";"
		
	# --- STANDARD LOGIC (Level 1 & 2) ---
	else:
		match required_type:
			"string":
				label_node.text = 'String s = "' + val_str + '";'
			"char":
				label_node.text = "char c = '" + val_str + "';"
			"float":
				label_node.text = "float f = " + val_str + "f;"
			"boolean":
				label_node.text = "boolean b = " + val_str + ";"
			_:
				label_node.text = display_type + " x = " + val_str + ";"
