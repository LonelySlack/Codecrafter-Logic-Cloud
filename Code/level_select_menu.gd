extends Control

@onready var data_btn_2 = $HBoxContainer/VBoxContainer4/dataBtn2
@onready var data_btn_3 = $HBoxContainer/VBoxContainer4/dataBtn3

@onready var exp_btn_2 = $HBoxContainer/VBoxContainer/expreBtn2
@onready var exp_btn_3 = $HBoxContainer/VBoxContainer/expreBtn3

@onready var func_btn_2 = $HBoxContainer/VBoxContainer2/functionBtn2
@onready var func_btn_3 = $HBoxContainer/VBoxContainer2/functionBtn3

func _ready():
	data_btn_2.disabled = not UserData.is_level_unlocked("data", 2)
	data_btn_3.disabled = not UserData.is_level_unlocked("data", 3)
	exp_btn_2.disabled = not UserData.is_level_unlocked("expression", 2)
	exp_btn_3.disabled = not UserData.is_level_unlocked("expression", 3)
	func_btn_2.disabled = not UserData.is_level_unlocked("function", 2)
	func_btn_3.disabled = not UserData.is_level_unlocked("function", 3)

func _on_data_btn_1_pressed():
	get_tree().change_scene_to_file("res://Tutorial.tscn")

func _on_function_btn_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Level_Function_1.tscn")

func _on_expre_btn_1_pressed() -> void:
	get_tree().change_scene_to_file("res://andOr.tscn")

func _on_function_btn_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Level_Function_2.tscn")

func _on_function_btn_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Level_Function_3.tscn")

func _on_expre_btn_2_pressed() -> void:
	get_tree().change_scene_to_file("res://andOr2.tscn")

func _on_expre_btn_3_pressed() -> void:
	get_tree().change_scene_to_file("res://andOr3.tscn")

func _on_data_btn_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Turorial2.tscn")

func _on_data_btn_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Turorial3.tscn")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")