# OrButton.gd
# Attach this script to your draggable "OR" button
extends Button

# This function runs when you start dragging this button
func _get_drag_data(at_position):

	# 1. Create the data payload.
	var data = {
		"type": "or_node" # <-- This is the new type
	}

	# 2. (Optional) Create a preview
	var preview_label = Label.new()
	preview_label.text = "OR"
	preview_label.modulate = Color.PURPLE # Make it match
	preview_label.set_size(Vector2(100, 50))
	
	set_drag_preview(preview_label)
	print("Starting drag for an or_node")
	return data
