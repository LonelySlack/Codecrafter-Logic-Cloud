# NotButton.gd
# Attach this script to your draggable "NOT" button
extends Button

# This function runs when you start dragging this button
func _get_drag_data(at_position):

	# 1. Create the data payload.
	var data = {
		"type": "not_node" # <-- This tells the GraphEdit to create a NotNode
	}

	# 2. Create the visual preview
	var preview_label = Label.new()
	preview_label.text = "NOT"
	preview_label.modulate = Color.RED # Red is commonly used for "Stop/Invert"
	preview_label.set_size(Vector2(100, 50))
	
	# Center the preview on the mouse
	var control = Control.new()
	control.add_child(preview_label)
	preview_label.position = Vector2(-30, -15) # approximate centering
	
	set_drag_preview(control)
	print("Starting drag for a not_node")
	return data
