extends ColorRect

@onready var continue_button = $"CenterContainer/VBoxContainer/Continue Button"
@onready var menu_button = $"CenterContainer/VBoxContainer/Menu button"

func _ready():
	continue_button.pressed.connect(_on_continue_pressed)
	menu_button.pressed.connect(_on_menu_pressed)

func _on_continue_pressed():
	get_tree().paused = false
	UserData.unlock_next_level("data", 1)
	get_tree().change_scene_to_file("res://DataTypeLevel2.tscn")

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/level_select_menu.tscn")