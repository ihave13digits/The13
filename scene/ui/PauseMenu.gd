extends CanvasLayer



func _on_Continue_button_up():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_parent().player.has_control = true
	queue_free()

func _on_Settings_button_up():
	var menu = load("res://scene/ui/Settings.tscn").instance()
	get_parent().add_child(menu)
	menu.connect('update_quality', get_parent(),'update_quality')
	queue_free()

func _on_Exit_button_up():
	get_tree().quit()
