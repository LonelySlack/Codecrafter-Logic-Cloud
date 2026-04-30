extends Control
class_name CombinerSlot

var contents: Array[Control] = []

signal token_dropped(token: Control)

func can_drop(_token: Control) -> bool:
	return contents.size() < 2

func drop(token: Control) -> void:
	contents.append(token)
	var n := contents.size()
	# place tokens side-by-side inside the combiner
	token.global_position = global_position + Vector2(16 + (n - 1) * 56, 16)
	token.z_index = 2
	emit_signal("token_dropped", token)
