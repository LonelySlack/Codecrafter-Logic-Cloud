# color_source.gd
extends TextureRect

# This will hold the scene of the item we want to drag (DraggableColor.tscn)
@export var draggable_scene: PackedScene
var color_name: String = "blue" # You can change this for red, yellow, etc.

# This function is automatically called by Godot when a drag starts on this control.
func _get_drag_data(at_position: Vector2) -> Variant:
	# 1. Create the preview that will follow the mouse
	var preview = TextureRect.new()
	preview.texture = self.texture
	preview.size = self.size
	# Center the preview on the mouse cursor
	preview.position = -preview.size / 2
	
	set_drag_preview(preview)
	
	# 2. Package the data you want to "drop" later.
	#    We'll send the scene and the color name.
	var data = {
		"scene": draggable_scene,
		"color": color_name
	}
	
	return data
