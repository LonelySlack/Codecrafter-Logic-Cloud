# block.gd
extends GraphNode
@tool  # so changes show up while editing

# --- Basic config you can tweak in the Inspector ---
@export var block_kind: String = "Block"

# Port enable flags
@export var left_enabled: bool = true
@export var right_enabled: bool = true

# Port "types" (ints you can use later to restrict valid connections)
@export var left_type: int = 0
@export var right_type: int = 0

# Port colors
@export var left_color: Color = Color(0.7, 0.7, 0.7)    # input side
@export var right_color: Color = Color(1.0, 0.8, 0.3)   # output side

func _ready() -> void:
	title = block_kind
	_rebuild_slots()
	# Optional niceties:
	resizable = true  # allow resizing the GraphNode by dragging its bottom-right handle

func _notification(what: int) -> void:
	# When edited in the inspector, refresh ports live
	if what == NOTIFICATION_POSTINITIALIZE or what == NOTIFICATION_EDITOR_PROPERTY_CHANGED:
		title = block_kind
		_rebuild_slots()

func _rebuild_slots() -> void:
	# IMPORTANT: Godot 4.4 set_slot signature does NOT include labels or textures
	# set_slot(slot_index,
	#          enable_left,  type_left,  color_left,
	#          enable_right, type_right, color_right,
	#          custom_icon_left := null, custom_icon_right := null, draw_stylebox := true)
	clear_all_slots()
	set_slot(
		0,
		left_enabled,  left_type,  left_color,
		right_enabled, right_type, right_color
	)
