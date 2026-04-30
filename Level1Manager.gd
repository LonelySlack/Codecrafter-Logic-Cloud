extends Control

# --- UNIVERSAL CONFIGURATION ---
@export var buckets: Array[TextureRect]
@export var next_level_id: int = 2

# [IMPROVEMENT] This box appears in the Inspector!
# Paste your level-specific guide here instead of hardcoding it.
@export_multiline var level_guide_text: String = "[center]System Online...[/center]"

@onready var log_label = %RichTextLabel 

var solved_count = 0
var total_puzzles_needed = 0

func _ready():
	# 1. SETUP TUTORIAL TEXT DYNAMICALLY
	# The script now uses whatever you typed in the Inspector.
	log_label.text = level_guide_text
	
	# 2. CALCULATE OBJECTIVES
	# Filter out empty slots just in case you left one blank in the inspector
	var valid_buckets = []
	for b in buckets:
		if b != null:
			valid_buckets.append(b)
	
	total_puzzles_needed = valid_buckets.size()
	
	# 3. CONNECT BUCKETS
	for bucket in valid_buckets:
		if bucket.has_signal("puzzle_solved"):
			bucket.puzzle_solved.connect(_on_bucket_solved)

	# 4. START SYSTEM LOG
	log_label.append_text("\n\n[color=gray]---------------- SYSTEM LOG ----------------[/color]")
	update_log("System initialized. Objectives loaded: " + str(total_puzzles_needed), false)

func update_log(message: String, is_error: bool):
	var color = "red" if is_error else "green"
	var prefix = "[ERROR]" if is_error else "[SUCCESS]"
	var final_text = "\n[color=%s]%s %s[/color]" % [color, prefix, message]
	
	log_label.append_text(final_text)
	
	await get_tree().process_frame
	var scroll_container = log_label.get_parent()
	if scroll_container is ScrollContainer:
		scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value

func _on_bucket_solved():
	solved_count += 1
	if solved_count >= total_puzzles_needed:
		level_complete()

func level_complete():
	update_log("ALL SYSTEMS ONLINE. LEVEL CLEARED.", false)
	
	# Unlock the next level dynamically
	if UserData:
		UserData.unlock_next_level("data", next_level_id)
	
	await get_tree().create_timer(1.5).timeout
	
	# DELETE the "if FileAccess..." check. Just run this line directly:
	get_tree().change_scene_to_file("res://Scene/level_select_menu.tscn")
