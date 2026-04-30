extends HSplitContainer

@export var top_margin_px: int = 64:
	set(value):
		top_margin_px = value
		_update_margins()

func _ready():
	_update_margins()

func _update_margins():
	# Anchors fill parent
	anchor_left = 0.0
	anchor_right = 1.0
	anchor_top = 0.0
	anchor_bottom = 1.0

	# Apply offsets
	offset_left = 0
	offset_right = 0
	offset_bottom = 0
	offset_top = top_margin_px
