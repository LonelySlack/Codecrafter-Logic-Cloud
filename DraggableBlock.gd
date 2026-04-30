@tool
extends Area2D
## Script for the main body of a draggable block.

# This signal is essential. It tells the WireManager to redraw
# all its connection lines, which needs to happen as the block moves.
signal block_moved

var is_dragging = false

func _ready():
	# Ensure mouse events are processed by this area.
	input_pickable = true

func _input_event(viewport, event, shape_idx):
	# This function is called ONLY when the mouse interacts with this Area2D's shape.
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			# We've handled this click, so stop it from propagating (e.g., to a port).
			get_viewport().set_input_as_handled()
		else:
			is_dragging = false

func _input(event):
	# We also check global input to handle a mouse release that happens
	# *outside* the block's area, which stops the drag.
	if is_dragging and event is InputEventMouseButton and \
	event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		is_dragging = false

func _process(delta):
	if is_dragging:
		# Update the block's position to follow the mouse.
		global_position = get_global_mouse_position()
		# Emit the signal so the WireManager knows to redraw the lines.
		emit_signal("block_moved")
