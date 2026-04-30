extends Control

@onready var title_label: Label = $CenterContainer/VBoxContainer/TitleLabel
@onready var subtitle_label: Label = $CenterContainer/VBoxContainer/SubtitleLabel
@onready var button_container: VBoxContainer = $CenterContainer/VBoxContainer/ButtonContainer
@onready var play_btn: Button = $CenterContainer/VBoxContainer/ButtonContainer/PlayButton
@onready var how_to_play_btn: Button = $CenterContainer/VBoxContainer/ButtonContainer/HowToPlayButton
@onready var quit_btn: Button = $CenterContainer/VBoxContainer/ButtonContainer/QuitButton

var title_tween: Tween
var glow_color := Color(0.3, 0.7, 1.0, 1.0)

func _ready() -> void:
	Music.play_track_instant("main")
	_setup_buttons()
	_animate_entrance()
	_start_title_glow()

func _setup_buttons() -> void:
	var buttons: Array[Button] = [play_btn, how_to_play_btn, quit_btn]
	for btn in buttons:
		btn.mouse_entered.connect(_on_button_hover.bind(btn))
		btn.mouse_exited.connect(_on_button_unhover.bind(btn))

func _animate_entrance() -> void:
	title_label.modulate.a = 0.0
	subtitle_label.modulate.a = 0.0
	for child in button_container.get_children():
		child.modulate.a = 0.0
		child.position.y += 30

	var entrance_tween := create_tween()
	entrance_tween.set_parallel(false)
	entrance_tween.tween_property(title_label, "modulate:a", 1.0, 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	entrance_tween.tween_property(subtitle_label, "modulate:a", 1.0, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

	entrance_tween.set_parallel(true)
	for i in range(button_container.get_child_count()):
		var child: Control = button_container.get_child(i)
		entrance_tween.tween_property(child, "modulate:a", 1.0, 0.4).set_delay(i * 0.12).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		entrance_tween.tween_property(child, "position:y", child.position.y - 30, 0.4).set_delay(i * 0.12).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func _start_title_glow() -> void:
	title_tween = create_tween().set_loops()
	title_tween.tween_property(title_label, "modulate", Color(1.0, 1.0, 1.0, 1.0), 2.0).set_ease(Tween.EASE_IN_OUT)
	title_tween.tween_property(title_label, "modulate", Color(0.85, 0.92, 1.0, 1.0), 2.0).set_ease(Tween.EASE_IN_OUT)

func _on_button_hover(btn: Button) -> void:
	var hover_tween := create_tween()
	hover_tween.tween_property(btn, "scale", Vector2(1.08, 1.08), 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	hover_tween.parallel().tween_property(btn, "modulate", Color(1.15, 1.15, 1.15, 1.0), 0.15)

func _on_button_unhover(btn: Button) -> void:
	var unhover_tween := create_tween()
	unhover_tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.15).set_ease(Tween.EASE_OUT)
	unhover_tween.parallel().tween_property(btn, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.15)

func _on_play_button_pressed() -> void:
	_transition_to_scene("res://Scene/level_select_menu.tscn")

func _on_how_to_play_button_pressed() -> void:
	_transition_to_scene("res://Scene/how_to_play.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _transition_to_scene(scene_path: String) -> void:
	var fade_tween := create_tween()
	fade_tween.tween_property(self, "modulate:a", 0.0, 0.3).set_ease(Tween.EASE_IN)
	await fade_tween.finished
	get_tree().change_scene_to_file(scene_path)
