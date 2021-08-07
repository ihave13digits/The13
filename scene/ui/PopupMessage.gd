extends Control

var message



func _ready():
	$Text.text = message

func _on_Anim_animation_finished(_anim_name):
	queue_free()
