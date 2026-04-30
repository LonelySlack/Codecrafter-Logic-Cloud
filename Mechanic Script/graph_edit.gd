# graph_edit.gd
# ATTACH TO: Your GraphEdit node
extends GraphEdit

# ─────────────────────────────────────────────────────────────
# LEVEL CONFIGURATION
# ─────────────────────────────────────────────────────────────
enum LevelMode { COLOR_MIXING, LOGIC_FUNCTIONS }

@export_group("Level Configuration")
@export var level_mode : LevelMode = LevelMode.COLOR_MIXING
@export var split_node_scene : PackedScene

@export_subgroup("Color Mixing Mode")
@export var goal_color_name : String = "purple"

@export_subgroup("Logic Functions Mode")
@export var goal_logic_result : String = "white"

@export_group("Unlock Next Level")
@export var unlock_category : String = "function"
@export var unlock_level_number : int = 2   # This is the NEXT level to unlock

# ─────────────────────────────────────────────────────────────
# DRAGGABLE NODE SCENES
# ─────────────────────────────────────────────────────────────
@export var combine_node_scene : PackedScene
@export var and_node_scene : PackedScene
@export var or_node_scene : PackedScene
@export var not_node_scene : PackedScene
@export var color_node_scene : PackedScene

# ─────────────────────────────────────────────────────────────
# INTERNAL STATE
# ─────────────────────────────────────────────────────────────
var level_is_complete := false
var color_node_data := {}  # instance_id → color name

# ─────────────────────────────────────────────────────────────
# LOGIC RECIPES
# ─────────────────────────────────────────────────────────────
var logic_recipes := {
	0: { "name": "black", "color": Color.BLACK, "texture": preload("res://Picture/Black.png") },
	1: { "name": "white", "color": Color.WHITE, "texture": preload("res://Picture/White.png") }
}

# ─────────────────────────────────────────────────────────────
# GODOT CALLBACKS
# ─────────────────────────────────────────────────────────────
func _ready() -> void:
	connection_request.connect(_on_connection_request)
	disconnection_request.connect(_on_disconnection_request)
	right_disconnects = true
	print("GraphEdit ready → Mode:", ["COLOR_MIXING", "LOGIC_FUNCTIONS"][level_mode])

# ─────────────────────────────────────────────────────────────
# DRAG & DROP
# ─────────────────────────────────────────────────────────────
func _can_drop_data(_at_position, data) -> bool:
	return data is Dictionary and data.get("type") in [
		"color_node",
		"combine_node",
		"split_node",
		"and_node",
		"or_node",
		"not_node"
	]

func _drop_data(at_position: Vector2, data) -> void:
	var pos = at_position + scroll_offset
	match data["type"]:
		"combine_node": _add_node_from_scene(combine_node_scene, pos)
		"split_node":   _add_node_from_scene(split_node_scene, pos)
		"and_node":     _add_logic_node(and_node_scene, "and", pos)
		"or_node":      _add_logic_node(or_node_scene, "or", pos)
		"not_node":     _add_logic_node(not_node_scene, "not", pos)
		"color_node":   _create_color_node(data.name, data.color, data.texture, pos)

func _add_node_from_scene(scene: PackedScene, pos: Vector2) -> void:
	if scene:
		var node = scene.instantiate()
		node.position_offset = pos
		add_child(node)

func _add_logic_node(scene: PackedScene, logic_type: String, pos: Vector2) -> void:
	if scene:
		var node = scene.instantiate()
		node.set_meta("logic_type", logic_type)
		node.position_offset = pos
		add_child(node)

# ─────────────────────────────────────────────────────────────
# CREATE RESULT NODE
# ─────────────────────────────────────────────────────────────
func _create_color_node(color_name: String, color_value: Color, texture: Texture2D, at_position: Vector2) -> void:
	var node = GraphNode.new()
	node.title = " "
	node.add_theme_constant_override("close_button_visible", 0)
	node.resizable = false
	node.set_slot(0, false, 0, Color.WHITE, true, 0, color_value)
	node.add_theme_stylebox_override("titlebar", StyleBoxEmpty.new())
	
	var tex_rect = TextureRect.new()
	tex_rect.texture = texture
	tex_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tex_rect.custom_minimum_size = Vector2(80, 80)
	node.add_child(tex_rect)
	
	node.position_offset = at_position
	add_child(node)
	
	color_node_data[node.get_instance_id()] = color_name
	print("Created result:", color_name)

# ─────────────────────────────────────────────────────────────
# CONNECTIONS
# ─────────────────────────────────────────────────────────────
func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	var from_node_real = get_node(NodePath(from_node))
	var to_node_real = get_node(NodePath(to_node))
	if not is_instance_valid(from_node_real): return
	
	var color_name = color_node_data.get(from_node_real.get_instance_id())
	if not color_name: return
	
	connect_node(from_node, from_port, to_node, to_port)
	
	if to_node_real.has_method("set_color_input"):
		to_node_real.set_color_input(to_port, color_name)
	elif to_node_real.has_method("set_value_input"):
		if color_name in ["white", "black"]:
			to_node_real.set_value_input(to_port, color_name)
		else:
			disconnect_node(from_node, from_port, to_node, to_port)

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)
	var to_node_real = get_node(NodePath(to_node))
	if is_instance_valid(to_node_real):
		if to_node_real.has_method("clear_color_input"):
			to_node_real.clear_color_input(to_port)
		elif to_node_real.has_method("clear_value_input"):
			to_node_real.clear_value_input(to_port)

func _clear_all_connections() -> void:
	var list = get_connection_list()
	for c in list:
		disconnect_node(c.from_node, c.from_port, c.to_node, c.to_port)
		var target = get_node_or_null(NodePath(c.to_node))
		if target:
			if target.has_method("clear_color_input"):
				target.clear_color_input(c.to_port)
			elif target.has_method("clear_value_input"):
				target.clear_value_input(c.to_port)

# ─────────────────────────────────────────────────────────────
# RUN BUTTON
# ─────────────────────────────────────────────────────────────
func _on_run_pressed() -> void:
	if level_is_complete: return
	print("RUN pressed!")
	
	var combine_nodes := []
	var logic_nodes := []
	var split_nodes := []
	
	# Categorize all children nodes
	for child in get_children():
		# Check "is_split" FIRST to distinguish it from generic combine nodes
		if child.has_method("is_split") and child.has_method("get_input_names"):
			split_nodes.append(child)
		elif child.has_method("get_input_names"):
			combine_nodes.append(child)
		elif child.has_method("get_input_values"):
			logic_nodes.append(child)
	
	# COLOR MIXING
	if level_mode == LevelMode.COLOR_MIXING:
		
		# 1. PROCESS COMBINE NODES
		for node in combine_nodes:
			var inputs = node.get_input_names()
			if inputs.size() == 2:
				var result_name = ColorDatabase.mix_colors(inputs[0], inputs[1])
				if result_name != "black":
					_spawn_result_node(result_name, node.position_offset + Vector2(280, 60))

		# 2. PROCESS SPLIT NODES
		for node in split_nodes:
			var inputs = node.get_input_names()
			if inputs.size() == 1:
				var base_color = inputs[0]
				var results = ColorDatabase.split_color(base_color)

				# If primary color → duplicate (or if splitting fails)
				if results.size() != 2:
					results = [base_color, base_color]

				# Spawn 2 output nodes
				for i in range(2):
					_spawn_result_node(results[i], node.position_offset + Vector2(280, 40 + i * 90))

	# LOGIC FUNCTIONS
	elif level_mode == LevelMode.LOGIC_FUNCTIONS:
		for node in logic_nodes:
			var values = node.get_input_values()
			var type = node.get_meta("logic_type", "none")
			var result_val = -1
			
			if type == "not" and values.size() > 0 and values[0] != -1:
				result_val = 1 if values[0] == 0 else 0
			elif values.size() >= 2 and values[0] != -1 and values[1] != -1:
				if type == "and": result_val = values[0] & values[1]
				if type == "or":  result_val = values[0] | values[1]
			
			if result_val != -1:
				var r = logic_recipes[result_val]
				_spawn_result_node(r.name, node.position_offset + Vector2(280, 60))
	
	_clear_all_connections()

# Helper to spawn result nodes and check win condition
func _spawn_result_node(result_name: String, pos: Vector2) -> void:
	var result_color = ColorDatabase.get_color_value(result_name)
	# Safely load texture
	var texture_path = "res://Picture/" + result_name.capitalize() + ".png"
	var texture = load(texture_path) if ResourceLoader.exists(texture_path) else preload("res://Picture/White.png")
	
	# Check for Logic Mode override (logic mode uses white/black as result names)
	if level_mode == LevelMode.LOGIC_FUNCTIONS and result_name in ["black", "white"]:
		var val = 0 if result_name == "black" else 1
		result_color = logic_recipes[val].color
		texture = logic_recipes[val].texture

	_create_color_node(result_name, result_color, texture, pos)
	
	# Win Condition Check
	var won = false
	if level_mode == LevelMode.COLOR_MIXING and result_name == goal_color_name:
		won = true
	elif level_mode == LevelMode.LOGIC_FUNCTIONS and result_name == goal_logic_result:
		won = true
		
	if won:
		await get_tree().create_timer(0.6).timeout
		_win_level()

# ─────────────────────────────────────────────────────────────
# WIN LEVEL
# ─────────────────────────────────────────────────────────────
func _win_level() -> void:
	if level_is_complete: return
	print("LEVEL COMPLETE! → Unlocking", unlock_category, unlock_level_number)
	level_is_complete = true
	_clear_all_connections()
	UserData.unlock_next_level(unlock_category, unlock_level_number)
	await get_tree().create_timer(0.8).timeout
	get_tree().change_scene_to_file("res://Scene/level_select_menu.tscn")
