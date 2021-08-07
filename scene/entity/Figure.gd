extends Spatial

onready var hitbox = $Box/Shape

func _process(_delta):
	look_at(get_parent().player.translation, Vector3.UP)
	rotate_object_local(Vector3(0, 1, 0), 3.14159)

func hide_from_player():
	$AnimationPlayer.play("crouch")

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
