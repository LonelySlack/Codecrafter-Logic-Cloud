extends GraphEdit

func _ready():
	snapping_enabled = true
	snapping_distance = 32
	show_grid = true

func _on_Wiring_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	var from := get_node_or_null(NodePath(from_node))
	var to := get_node_or_null(NodePath(to_node))
	if from == null or to == null:
		return

	if from is ColorNode and to is CombineNode and to_port in [0, 1]:
		if _input_port_occupied(to_node, to_port):
			return
		connect_node(from_node, from_port, to_node, to_port)
		(to as CombineNode).set_color_input(to_port, (from as ColorNode).color_code)
		return

	if from is CombineNode and to is CombineNode and from_port == 2 and to_port in [0, 1]:
		if _input_port_occupied(to_node, to_port):
			return
		connect_node(from_node, from_port, to_node, to_port)
		var result: String = (from as CombineNode).get_meta("result_color", "")
		if result != "":
			(to as CombineNode).set_color_input(to_port, result)
		return

func _on_Wiring_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)
	var to := get_node_or_null(NodePath(to_node))
	if to is CombineNode and to_port in [0, 1]:
		(to as CombineNode).clear_color_input(to_port)

func _input_port_occupied(node_name: StringName, input_port: int) -> bool:
	for c in get_connection_list():
		if c.to_node == node_name and int(c.to_port) == input_port:
			return true
	return false