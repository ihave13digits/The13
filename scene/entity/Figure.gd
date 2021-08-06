extends Spatial

func _process(_delta):
	look_at(get_parent().player.translation, Vector3.UP)
	rotate_object_local(Vector3(0, 1, 0), 3.14159)

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
