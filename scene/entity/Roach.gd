extends KinematicBody

var gravity = Vector3.DOWN * 0.5  # strength of gravity
var turn_speed = 2.5
var speed = 10
var vel = Vector3()

func _ready():
	$Body/AnimationPlayer.playback_speed = 2.5



func _process(delta):
	#vel += gravity
	if $Body/Head/Forward.get_collider() == null:
		vel -= get_transform().basis.z
	if $Body/Head/Evading != null:
		vel -= get_transform().basis.z
		if $Body/Head/Right.get_collider() != null:
			rotate_object_local(Vector3(0,1,0), turn_speed*delta)
			vel += get_transform().basis.z
			$Body/AnimationPlayer.play("scurry")
		elif $Body/Head/Left.get_collider() != null:
			rotate_object_local(Vector3(0,1,0), -turn_speed*delta)
			vel += get_transform().basis.z
			$Body/AnimationPlayer.play("scurry")

	var motion = vel.normalized() * (speed * delta)
	vel = move_and_slide(motion)



func _on_AnimationPlayer_animation_finished(_anim_name):
	if $Body/Head/Grabbing.is_colliding():
		vel = Vector3()
	$Body/AnimationPlayer.play("scurry")
	
