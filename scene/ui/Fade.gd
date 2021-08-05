extends CanvasLayer
signal end_game
onready var anim 



# Called when the node enters the scene tree for the first time.
func _ready():
	anim = $Center/Fade





func _on_Fade_animation_finished(_anim_name):
	emit_signal("end_game")
