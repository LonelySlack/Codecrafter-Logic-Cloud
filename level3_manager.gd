extends Control

# Track how many puzzles are done
var solved_count = 0
var total_puzzles_needed = 3

# --- BUCKETS FOR LEVEL 3: Arrays! ---
@export var bucket_int_array: TextureRect
@export var bucket_string_array: TextureRect
@export var bucket_char_array: TextureRect

func _ready():
	# Connect the signals safely
	if bucket_int_array:
		bucket_int_array.puzzle_solved.connect(_on_bucket_solved)
	if bucket_string_array:
		bucket_string_array.puzzle_solved.connect(_on_bucket_solved)
	if bucket_char_array:
		bucket_char_array.puzzle_solved.connect(_on_bucket_solved)

func _on_bucket_solved():
	solved_count += 1
	print("Puzzles solved: ", solved_count, " / ", total_puzzles_needed)
	if solved_count >= total_puzzles_needed:
		level_complete()

func level_complete():
	print("LEVEL 3 COMPLETE! 🎉 Arrays Mastered!")
	UserData.unlock_next_level("data", 3)
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scene/level_select_menu.tscn")
