extends TextureButton

func _pressed():
	print("Going Home...")
	# This function changes the scene to your level select menu
	get_tree().change_scene_to_file("res://Scene/level_select_menu.tscn")
