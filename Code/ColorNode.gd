extends GraphNode
class_name ColorNode

@onready var swatch: ColorRect = $Swatch

const VIS := {
	"RED": Color(1, 0.2, 0.2),
	"BLUE": Color(0.1, 0.2, 1.0),
	"YELLOW": Color(1.0, 0.9, 0.2),
	"GREEN": Color(0.2, 0.9, 0.2),
	"ORANGE": Color(1.0, 0.6, 0.2),
	"PURPLE": Color(0.6, 0.3, 1.0)
}

@export var color_code: String = "BLUE" : set = set_color_code

func _ready():
	# One output port on the RIGHT at slot index 0
	clear_all_slots()
	set_slot(0, false, 0, Color.WHITE, true, 0, Color.WHITE)
	set_color_code(color_code)

func set_color_code(v: String) -> void:
	color_code = v
	title = v
	if is_instance_valid(swatch):
		swatch.color = VIS.get(v, Color(0.8, 0.8, 0.8))
