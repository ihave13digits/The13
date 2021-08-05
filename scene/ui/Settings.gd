extends CanvasLayer



func _ready():
	if Data.env.environment.dof_blur_far_enabled:
		$Center/ToggleBlur.pressed = true
	else:
		$Center/ToggleBlur.pressed = false
	
	

func _on_BlurSettings_value_changed(value):
	match int(value):
		0:
			Data.env.environment.dof_blur_far_quality = Environment.DOF_BLUR_QUALITY_LOW
		1:
			Data.env.environment.dof_blur_far_quality = Environment.DOF_BLUR_QUALITY_MEDIUM
		2:
			Data.env.environment.dof_blur_far_quality = Environment.DOF_BLUR_QUALITY_HIGH

func _on_ToggleBlur_button_up():
	if $Center/ToggleBlur.pressed:
		Data.env.environment.dof_blur_far_enabled = true
	else:
		Data.env.environment.dof_blur_far_enabled = false

func _on_Done_button_up():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_parent().player.has_control = true
	queue_free()
