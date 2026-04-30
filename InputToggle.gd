extends GraphNode

var is_white = false

func _ready():
	title = "Input"
	_update_color()

func _toggle():
	is_white = !is_white
	_update_color()

func _update_color():
	var tex = preload("res://Picture/White.png") if is_white else preload("res://Picture/Black.png")
	var color_name = "white" if is_white else "black"
	$TextureRect.texture = tex
	set_meta("output_value", 1 if is_white else 0)
	set_meta("output_color_name", color_name)

func _get_drag_data(_at_position):
	return {
		"type": "color_node",
		"name": get_meta("output_color_name"),
		"color": Color.WHITE if is_white else Color.BLACK,
		"texture": $TextureRect.texture
	}