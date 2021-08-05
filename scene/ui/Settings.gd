extends CanvasLayer

var env



# Called when the node enters the scene tree for the first time.
func _ready():
	env = WorldEnvironment.new()
	env.set_environment(load("res://default_env.tres"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


###func _on_BlurSettings_value_changed(value):
	#pass # Replace with function body.


func _on_ToggleBlur_button_up():
	if !env.dof_far_blur_enabled:
		env.dof_far_blur_enabled = true
	else:
		env.dof_far_blur_enabled = false
