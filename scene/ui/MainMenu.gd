extends Spatial



func _ready():
	Data.env.environment.fog_depth_end = 8
	$LightmotionAnim.play("swing")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func toggle_visibility():
	$UI/Bottom.visible = !$UI/Bottom.visible

func play_click_anim(anim_name):
	$ClickAnim.play(anim_name)

func update_quality():
	$LightPivot/Lamp/Light.shadow_enabled = Data.bells_and_whistles

func _on_Play_button_up():
	play_click_anim('start')

func _on_Settings_button_up():
	play_click_anim('settings')

func _on_Exit_button_up():
	play_click_anim('exit')

func _on_ClickAnim_animation_finished(anim_name):
	match anim_name:
		'start' : 
			var _can_do = get_tree().change_scene("res://scene/Game.tscn")
		'settings' :
			var menu = load("res://scene/ui/Settings.tscn").instance()
			get_parent().add_child(menu)
			toggle_visibility()
			menu.connect('tree_exited', self, 'toggle_visibility')
			menu.connect('update_quality', self, 'update_quality')
		'exit' :
			get_tree().quit()



func _on_InteractLight_mouse_entered():
	$LightmotionAnim.seek(0.0)
	$LightAnim.seek(0.0)
	$LightmotionAnim.play("swing")
	$LightAnim.play("flicker")
