extends Control

# Track how many puzzles are done
var solved_count = 0
var total_puzzles_needed = 3

# --- BUCKETS FOR LEVEL 2: float, char, double ---
@export var bucket_float: TextureRect
@export var bucket_char: TextureRect
@export var bucket_double: TextureRect
# ----------------------------------------------

func _ready():
	# Connect the signals
	# We use "if" checks to prevent crashing if you forgot to assign one
	if bucket_float:
		bucket_float.puzzle_solved.connect(_on_bucket_solved)
	if bucket_char:
		bucket_char.puzzle_solved.connect(_on_bucket_solved)
	if bucket_double:
		bucket_double.puzzle_solved.connect(_on_bucket_solved)

func _on_bucket_solved():
	solved_count += 1
	print("Puzzles solved: ", solved_count, " / ", total_puzzles_needed)
	if solved_count >= total_puzzles_needed:
		level_complete()

func level_complete():
	print("LEVEL 2 COMPLETE!")
	UserData.unlock_next_level("data", 2)
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scene/level_select_menu.tscn")
