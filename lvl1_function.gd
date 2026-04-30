extends Control

func _go_back():
	get_tree().change_scene_to_file("res://Scene/level_select_menu.tscn")

func level_complete():
	print("FUNCTION LEVEL 1 COMPLETE!")
	UserData.unlock_next_level("function", 1)
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scene/level_select_menu.tscn")

var solved_count = 0
var total_puzzles_needed = 1

@export var puzzle_slot: Node

func _ready():
	if puzzle_slot and puzzle_slot.has_signal("puzzle_solved"):
		puzzle_slot.puzzle_solved.connect(_on_puzzle_solved)

func _on_puzzle_solved():
	solved_count += 1
	if solved_count >= total_puzzles_needed:
		level_complete()