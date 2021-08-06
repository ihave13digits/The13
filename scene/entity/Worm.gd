extends Spatial

var grab_target = null
onready var grab_point = $GrabPoint

func _physics_process(_delta):
	grab_point.translation.x = translation.x
	grab_point.translation.z = translation.z
	if grab_target != null:
		grab_target.translation = grab_point.translation
		grab_target.has_control = false

func _on_Jaw_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	if body.has_method('use_item'):
		grab_target = body
