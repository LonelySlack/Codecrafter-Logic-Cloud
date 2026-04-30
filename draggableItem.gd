extends TextureRect

# @export makes these variables appear in the Inspector
@export var item_type: String = "integer" 

# We use 'set' here so the Label updates automatically when you change this!
@export var item_value: String = "10":
	set(new_value):
		item_value = new_value
		_update_label_text()

# This runs when the game starts
func _ready():
	_update_label_text()

# This custom function finds the Label and updates its text
func _update_label_text():
	var label_node = get_node_or_null("Label")
	if label_node:
		label_node.text = item_value

# This function runs automatically when you try to drag the object
func _get_drag_data(_at_position):
	# 1. Prepare the data
	var data = {
		"type": item_type,
		"value": item_value
	}
	
	# 2. Create the "Ghost" preview
	var preview = TextureRect.new()
	preview.texture = texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.size = size
	preview.modulate.a = 0.5
	
	# --- NEW: Add a copy of the Label to the preview so we see the number while dragging! ---
	var original_label = get_node_or_null("Label")
	if original_label:
		var preview_label = original_label.duplicate()
		preview.add_child(preview_label)
		# Ensure the preview label is positioned correctly (optional, usually 0,0 is fine)
		preview_label.position = original_label.position 
	# --------------------------------------------------------------------------------------

	# Center the preview
	var preview_control = Control.new()
	preview_control.add_child(preview)
	preview.position = -0.5 * preview.size
	
	set_drag_preview(preview_control)
	
	return data
