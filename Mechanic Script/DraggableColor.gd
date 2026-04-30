# DraggableColor.gd
# Attach to: Red, Blue, Yellow, Black, White buttons (any color source)
extends Control

@export var color_name : String = "red"
@export var color_value : Color = Color.RED

@onready var texture_rect : TextureRect = $TextureRect

func _get_drag_data(_at_position: Vector2) -> Variant:
	if texture_rect.texture == null:
		return null

	var data = {
		"type": "color_node",
		"name": color_name.to_lower(),
		"color": color_value,
		"texture": texture_rect.texture.duplicate()
	}

	var preview = TextureRect.new()
	preview.texture = texture_rect.texture
	preview.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	preview.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	preview.custom_minimum_size = texture_rect.size * 0.6
	preview.modulate.a = 0.9
	set_drag_preview(preview)

	print("Dragging color:", data.name)
	return data