# DraggableButton.gd
extends Button

# EXPORT THIS! Now you can change it in the Inspector for each button.
@export_enum("combine_node", "split_node", "and_node", "or_node", "not_node") var node_type : String = "combine_node"

func _get_drag_data(at_position):
	# 1. Prepare data based on the exported variable
	var data = { "type": node_type }

	# 2. Create Preview
	var preview = Label.new()
	preview.text = node_type.capitalize().replace("_", " ") # e.g. "Combine Node"
	preview.modulate = Color(1, 1, 1, 0.8)
	
	# Center it
	var c = Control.new()
	c.add_child(preview)
	preview.position = Vector2(-30, -10)
	set_drag_preview(c)

	return data
