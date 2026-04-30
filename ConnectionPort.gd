@tool
extends Area2D
## Script for a connection port (input or output).

# Emitted when a user clicks this port to start dragging a wire.
signal wire_drag_started(port)

# Emitted when a user releases the mouse while over this port (completing a connection).
signal wire_drag_ended(port)

func _ready():
	# Make sure the port is pickable.
	input_pickable = true

func _input_event(viewport, event, shape_idx):
	# Called when the mouse interacts with *this port's* shape.
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Tell the manager we want to start drawing a wire from here.
			emit_signal("wire_drag_started", self)
			# Stop the click from being processed by the block underneath.
			get_viewport().set_input_as_handled()
		else:
			# The mouse was released *over* this port.
			emit_signal("wire_drag_ended", self)
			get_viewport().set_input_as_handled()
