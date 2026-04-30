# CombineNode.gd
extends GraphNode
class_name CombineNode

var name_a : String = ""
var name_b : String = ""

@onready var texture_rect = $TextureRect

func _ready():
	set_slot(0, true, 0, Color.WHITE, false, 0, Color.WHITE)
	set_slot(1, true, 0, Color.WHITE, false, 0, Color.WHITE)
	set_slot(2, false, 0, Color.WHITE, true, 0, Color.WHITE)
	texture_rect.modulate = Color(0.5, 0.5, 0.5)

func set_color_input(port: int, color_name: String):
	if port == 0:
		name_a = color_name
	elif port == 1:
		name_b = color_name
	_update_visual()

func clear_color_input(port: int):
	if port == 0:
		name_a = ""
	elif port == 1:
		name_b = ""
	_update_visual()

func get_input_names() -> Array[String]:
	var inputs: Array[String] = []
	if name_a != "": inputs.append(name_a)
	if name_b != "": inputs.append(name_b)
	return inputs

func _update_visual():
	if name_a == "" or name_b == "":
		texture_rect.modulate = Color(0.5, 0.5, 0.5)
		set_meta("result_color", "")
		return

	var result = ColorDatabase.mix_colors(name_a, name_b)
	if result == "":
		texture_rect.modulate = Color.WHITE
		set_meta("result_color", "")
		return

	texture_rect.modulate = ColorDatabase.get_color_value(result)
	set_meta("result_color", result)