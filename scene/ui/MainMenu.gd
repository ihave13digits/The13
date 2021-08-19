extends Spatial



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_Play_button_up():
	var _can_do = get_tree().change_scene("res://scene/Game.tscn")
