# CombineNode.gd - STABLE VERSION
extends GraphNode

var color_a_name : String = ""
var color_b_name : String = ""

@onready var texture_rect = $TextureRect

func _ready():
	set_slot(0, true, 0, Color.WHITE, false, 0, Color.WHITE)
	set_slot(1, true, 0, Color.WHITE, false, 0, Color.WHITE)
	set_slot(2, false, 0, Color.WHITE, true, 0, Color.WHITE)

func set_color_input(port: int, color_name: String):
	var clean_name = color_name.to_lower()
	if port == 0:
		color_a_name = clean_name
	elif port == 1:
		color_b_name = clean_name
	_update_visual()

func clear_color_input(port: int):
	if port == 0:
		color_a_name = ""
	elif port == 1:
		color_b_name = ""
	_update_visual()

func get_input_names() -> Array:
	var names = []
	if color_a_name != "": names.append(color_a_name)
	if color_b_name != "": names.append(color_b_name)
	return names

func _update_visual():
	if color_a_name == "" or color_b_name == "":
		texture_rect.modulate = Color(0.5, 0.5, 0.5)
		set_meta("result_color", "")
		return

	var result = ColorDatabase.mix_colors(color_a_name, color_b_name)
	if result == "":
		texture_rect.modulate = Color.WHITE
		set_meta("result_color", "")
		return

	texture_rect.modulate = ColorDatabase.get_color_value(result)
	set_meta("result_color", result)