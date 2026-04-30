@tool
extends Control

# ---------- tweakables ----------
@export var topbar_height_px: int = 56:
	set(value):
		topbar_height_px = max(36, value)
		_apply_layout()

@export var left_width_px: int = 300:
	set(value):
		left_width_px = max(180, value)
		_apply_layout()

@export var rebuild_now: bool = false:
	set(value):
		rebuild_now = false
		_build_ui()

# colors
@export var canvas_bg_color: Color    = Color(0.10, 0.12, 0.16)
@export var panel_bg_color: Color     = Color(0.12, 0.14, 0.18)
@export var panel_border_color: Color = Color(0.18, 0.20, 0.24)

# block spawn placement
var _next_spawn_x := 80
var _next_spawn_y := 80
# --------------------------------

func _enter_tree():
	if Engine.is_editor_hint():
		_build_ui()

func _ready():
	_build_ui()

# ================== UI BUILD ==================
func _build_ui():
	# clean slate
	for c in get_children():
		c.queue_free()

	set_anchors_preset(Control.PRESET_FULL_RECT)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical   = Control.SIZE_EXPAND_FILL

	# ---- Top Bar ----
	var topbar := PanelContainer.new()
	topbar.name = "TopBar"
	add_child(topbar)
	_style_panel(topbar, panel_bg_color, panel_border_color, 12, 1)
	topbar.custom_minimum_size = Vector2(0, topbar_height_px)

	var tb_h := HBoxContainer.new()
	tb_h.name = "HBoxContainer"
	tb_h.add_theme_constant_override("separation", 12)
	topbar.add_child(tb_h)

	var back := Button.new()
	back.name = "BackBtn"
	back.text = "◀  Back to Levels"
	back.flat = true
	tb_h.add_child(back)

	var title := Label.new()
	title.name = "TitleLbl"
	title.text = "Level 1: Combine Colors"
	title.add_theme_font_size_override("font_size", 18)
	tb_h.add_child(title)

	var spacer := Control.new()
	spacer.name = "TopSpacer"
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tb_h.add_child(spacer)

	var reset := Button.new()
	reset.name = "ResetBtn"
	reset.text = "Reset"
	reset.flat = true
	tb_h.add_child(reset)

	var run := Button.new()
	run.name = "RunBtn"
	run.text = "RUN"
	tb_h.add_child(run)

	# ---- Main Split (Left toolbox | Right canvas) ----
	var split := HSplitContainer.new()
	split.name = "MainSplit"
	add_child(split)

	# Left panel
	var left_panel := PanelContainer.new()
	left_panel.name = "LeftSidebar"
	_style_panel(left_panel, panel_bg_color, panel_border_color, 12, 1)
	left_panel.custom_minimum_size = Vector2(left_width_px, 0)
	split.add_child(left_panel)

	var left_margin := MarginContainer.new()
	left_margin.name = "MarginContainer"
	_set_margin_all(left_margin, 16)
	left_panel.add_child(left_margin)

	var toolbox := VBoxContainer.new()
	toolbox.name = "Toolbox"
	toolbox.add_theme_constant_override("separation", 12)
	left_margin.add_child(toolbox)

	var t_title := Label.new()
	t_title.name = "ToolboxTitle"
	t_title.text = "Logic Toolbox"
	t_title.add_theme_font_size_override("font_size", 18)
	toolbox.add_child(t_title)

	var t_obj := Label.new()
	t_obj.name = "Objective"
	t_obj.text = "Objective: Create YELLOW light."
	t_obj.autowrap_mode = TextServer.AUTOWRAP_WORD
	toolbox.add_child(t_obj)

	var grid := GridContainer.new()
	grid.name = "BlockGrid"
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	toolbox.add_child(grid)

	# Toolbox buttons (click-to-spawn for now)
	_add_block_button(grid, "AND")
	_add_block_button(grid, "OR")
	_add_block_button(grid, "NOT")
	_add_block_button(grid, "SRC (R)")
	_add_block_button(grid, "SRC (G)")
	_add_block_button(grid, "TARGET")

	# Right panel (canvas)
	var canvas_panel := PanelContainer.new()
	canvas_panel.name = "CanvasPanel"
	_style_panel(canvas_panel, panel_bg_color, panel_border_color, 12, 1)
	canvas_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	canvas_panel.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	split.add_child(canvas_panel)

	var canvas_margin := MarginContainer.new()
	canvas_margin.name = "MarginContainer"
	_set_margin_all(canvas_margin, 16)
	canvas_panel.add_child(canvas_margin)

	var canvas := Control.new()
	canvas.name = "CanvasArea"
	canvas.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	canvas.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	canvas.mouse_filter = Control.MOUSE_FILTER_PASS
	canvas_margin.add_child(canvas)

	var bg := ColorRect.new()
	bg.name = "BG"
	bg.color = canvas_bg_color
	bg.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bg.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	canvas.add_child(bg)
	bg.move_to_front()

	# layout + signals
	_apply_layout()

	back.pressed.connect(_go_back)
	reset.pressed.connect(_reset_canvas)
	run.pressed.connect(_run_check)

	# reset spawn positions
	_next_spawn_x = 80
	_next_spawn_y = 80


func _apply_layout():
	if not is_inside_tree():
		return

	var topbar  := $TopBar as Control
	var split   := $MainSplit as HSplitContainer

	# Topbar anchors at top
	topbar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	topbar.anchor_right  = 1.0
	topbar.anchor_left   = 0.0
	topbar.anchor_top    = 0.0
	topbar.anchor_bottom = 0.0
	topbar.offset_left   = 0
	topbar.offset_right  = 0
	topbar.offset_top    = 0
	topbar.offset_bottom = topbar_height_px

	# Split fills rest, pushed below topbar
	split.anchor_left   = 0.0
	split.anchor_right  = 1.0
	split.anchor_top    = 0.0
	split.anchor_bottom = 1.0
	split.offset_left   = 0
	split.offset_right  = 0
	split.offset_bottom = 0
	split.offset_top    = topbar_height_px

	# Left fixed width, right expands
	var left_panel := $MainSplit/LeftSidebar as Control
	var canvas_panel := $MainSplit/CanvasPanel as Control
	left_panel.custom_minimum_size.x = left_width_px
	left_panel.size_flags_horizontal = Control.SIZE_FILL
	canvas_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	canvas_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL


# ========== helpers ==========
func _add_block_button(grid: GridContainer, label: String) -> void:
	var b := Button.new()
	b.text = label
	b.custom_minimum_size.y = 44
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.pressed.connect(func():
		_spawn_block(label)
	)
	grid.add_child(b)

func _spawn_block(kind: String):
	var canvas := $MainSplit/CanvasPanel/MarginContainer/CanvasArea as Control

	# chip node
	var chip := ColorRect.new()
	var safe := kind.replace(" ", "_").replace("(", "").replace(")", "")
	chip.name = "Block_%s" % safe
	chip.size = Vector2(62, 62)
	chip.color = _chip_color_for(kind)
	chip.corner_radius_top_left = 12
	chip.corner_radius_top_right = 12
	chip.corner_radius_bottom_left = 12
	chip.corner_radius_bottom_right = 12
	chip.mouse_filter = Control.MOUSE_FILTER_STOP

	var lbl := Label.new()
	lbl.text = kind
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	chip.add_child(lbl)

	# position inside canvas
	chip.position = Vector2(_next_spawn_x, _next_spawn_y)
	canvas.add_child(chip)

	# simple click-drag behavior
	var dragging := false
	var grab := Vector2.ZERO
	chip.gui_input.connect(func(e):
		if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
			if e.pressed:
				dragging = true
				grab = e.position
				chip.grab_focus()
			else:
				dragging = false
		elif e is InputEventMouseMotion and dragging:
			chip.position += e.position - grab
	)

	# stagger spawn positions
	_next_spawn_x += 80
	if _next_spawn_x > canvas.size.x - 100:
		_next_spawn_x = 80
		_next_spawn_y += 80

func _chip_color_for(kind: String) -> Color:
	match kind:
		"SRC (R)": return Color(0.85, 0.25, 0.25)
		"SRC (G)": return Color(0.25, 0.85, 0.35)
		"TARGET":  return Color(0.95, 0.55, 0.20)
		"AND":     return Color(0.30, 0.34, 0.40)
		"OR":      return Color(0.30, 0.34, 0.40)
		"NOT":     return Color(0.30, 0.34, 0.40)
		_:         return Color(0.35, 0.40, 0.46)

func _style_panel(p: PanelContainer, bg: Color, border: Color, radius: float, bw: int):
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	sb.border_color = border
	sb.border_width_all = bw
	sb.corner_radius_top_left = radius
	sb.corner_radius_top_right = radius
	sb.corner_radius_bottom_left = radius
	sb.corner_radius_bottom_right = radius
	p.add_theme_stylebox_override("panel", sb)

func _set_margin_all(m: MarginContainer, px: int):
	m.add_theme_constant_override("margin_left", px)
	m.add_theme_constant_override("margin_top", px)
	m.add_theme_constant_override("margin_right", px)
	m.add_theme_constant_override("margin_bottom", px)


# ========== buttons ==========
func _go_back():
	get_tree().change_scene_to_file("res://Scene/level_select_menu.tscn")

func _reset_canvas():
	var canvas := $MainSplit/CanvasPanel/MarginContainer/CanvasArea
	for c in canvas.get_children():
		if c.name != "BG":
			c.queue_free()
	_next_spawn_x = 80
	_next_spawn_y = 80

func _run_check():
	var canvas := $MainSplit/CanvasPanel/MarginContainer/CanvasArea
	var has_r := false
	var has_g := false
	var has_t := false
	for c in canvas.get_children():
		if c is ColorRect and c.name.begins_with("Block_"):
			var k := (c.get_node("Label") as Label).text
			match k:
				"SRC (R)": has_r = true
				"SRC (G)": has_g = true
				"TARGET":  has_t = true
	var dlg := AcceptDialog.new()
	dlg.title = "Result"
	dlg.dialog_text = "✅ Success! You created YELLOW." \
		if (has_r and has_g and has_t) \
		else "❌ Not yet. Place SRC (R), SRC (G), and TARGET."
	add_child(dlg)
	dlg.popup_centered()
