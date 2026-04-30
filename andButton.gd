# AndButton.gd
# Attach this script to your draggable "AND" button
extends Button

# This function runs when you start dragging this button
func _get_drag_data(at_position):

	# 1. Create the data payload.
	var data = {
		"type": "and_node"
	}

	# 2. (Optional) Create a preview
	var preview_label = Label.new()
	preview_label.text = "AND"
	preview_label.modulate = Color.PINK # Make it match
	preview_label.set_size(Vector2(100, 50))
	
	set_drag_preview(preview_label)
	print("Starting drag for an and_node")
	return data
