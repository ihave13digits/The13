extends CanvasLayer

signal end_game

onready var anim = $Center/Fade



func _on_Fade_animation_finished(_anim_name):
	emit_signal("end_game")
