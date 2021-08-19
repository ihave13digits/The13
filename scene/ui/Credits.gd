extends CanvasLayer

var credit_text = """
The 13



Credits:


art,
code,
models,

by ihave13digits


music,
sound design,
level design,

by reaply


story,
game design,
user interface,

by reaply and ihave13digits



Special Thanks:


sourced sound effects by:

monte32



Last, but not least, a big thanks to the Godot engine for making this game a reality
"""



func _ready():
	$Center/CreditText.text = credit_text
	$Anim.play("credit_roll")

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		$Anim.stop()
		end_credits()



func end_credits():
	var _can_do = get_tree().change_scene("res://scene/ui/MainMenu.tscn")



func _on_Anim_animation_finished(_anim_name):
	end_credits()
