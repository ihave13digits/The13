extends CanvasLayer



func _ready():
	# Toggles
	$Center/ToggleBlur.pressed = Data.env.environment.dof_blur_far_enabled
	$Center/TogglePostProcessing.pressed = Data.env.environment.adjustment_enabled
	$Center/ToggleBellsAndWhistles.pressed = Data.bells_and_whistles
	# Sliders
	$Center/RenderingDistance.value = Data.settings['render_distance']
	$Center/BlurSettings.value = Data.env.environment.dof_blur_far_quality
	# Slider Visibility
	$Center/BlurSettings.visible = Data.env.environment.dof_blur_far_enabled

func _on_BlurSettings_value_changed(value):
	match int(value):
		0 : Data.env.environment.dof_blur_far_quality = Environment.DOF_BLUR_QUALITY_LOW
		1 : Data.env.environment.dof_blur_far_quality = Environment.DOF_BLUR_QUALITY_MEDIUM
		2 : Data.env.environment.dof_blur_far_quality = Environment.DOF_BLUR_QUALITY_HIGH

func _on_RenderingDistance_value_changed(value):
	Data.settings['render_distance'] = value



func _on_ToggleBlur_button_up():
	Data.env.environment.dof_blur_far_enabled = $Center/ToggleBlur.pressed
	$Center/BlurSettings.visible = Data.env.environment.dof_blur_far_enabled

func _on_TogglePostProcessing_button_up():
	Data.env.environment.adjustment_enabled = $Center/TogglePostProcessing.pressed

func _on_ToggleBellsAndWhistles_button_up():
	Data.bells_and_whistles = $Center/ToggleBellsAndWhistles.pressed
	if get_parent().has_method("update_quality"):
		get_parent().update_quality()



func _on_Done_button_up():
	if get_parent().has_method("update_quality"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_parent().player.has_control = true
	queue_free()
