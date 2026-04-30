extends TextureButton
# NOTE: If your node is a normal "Button", change the line above to "extends Button"

func _pressed():
	# This function runs automatically when the button is clicked
	print("Restarting Level...")
	get_tree().reload_current_scene()
