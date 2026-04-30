# combine.gd
extends TextureRect

# --- DRAG LOGIC (to make this block draggable) ---
## Drag the combine scene itself into this slot in the Inspector.
@export var draggable_scene: PackedScene


# --- DROP LOGIC (to receive colors) ---
## This array stores the names of the colors currently inside the combine box.
var colors_in_zone: Array[String] = []


# This function runs when you start dragging THIS combine block.
func _get_drag_data(at_position: Vector2) -> Variant:
	if not draggable_scene:
		print("ERROR: Assign the Combine scene to its own Draggable Scene slot in the Inspector.")
		return null

	# Create a preview of the combine block itself.
	var preview = TextureRect.new()
	preview.texture = self.texture
	preview.size = self.size
	preview.position = -preview.size / 2
	set_drag_preview(preview)

	# Package its own scene to be instantiated by the panel.
	var data = {"scene": draggable_scene, "color": "combiner"} # Color can be a unique ID
	return data


# This function checks if we can accept a color being dropped ONTO us.
func _can_drop_data(at_position, data):
	return data.has("scene") and data.has("color") and data.color != "combiner"


# This function executes when a color is dropped ONTO us.
func _drop_data(at_position, data):
	var incoming_color = data.color as String
	
	if not colors_in_zone.has(incoming_color):
		print("Added '", incoming_color, "' to the combine box.")
		colors_in_zone.append(incoming_color)
		self.modulate = Color.GOLD # Visual feedback
		check_for_combination()
	else:
		print("Combine box already contains '", incoming_color, "'.")


func check_for_combination():
	print("Current colors in zone: ", colors_in_zone)
	if colors_in_zone.has("blue") and colors_in_zone.has("yellow"):
		print("SUCCESS! Combined BLUE and YELLOW to make GREEN!")
		clear_zone()
	elif colors_in_zone.has("blue") and colors_in_zone.has("red"):
		print("SUCCESS! Combined BLUE and RED to make PURPLE!")
		clear_zone()


func clear_zone():
	print("--- Combination successful, clearing zone. ---")
	colors_in_zone.clear()
	self.modulate = Color.WHITE
