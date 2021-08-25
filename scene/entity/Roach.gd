extends KinematicBody

var gravity = Vector3.DOWN * 0.5  # strength of gravity
var turn_speed = 2.5
export (int) var speed = 10
var vel = Vector3()
var state = 0

onready var anim = $Body/AnimationPlayer

func _ready():
	speed = 10+scale.z
	set_state(0, 1.25)



func _process(delta):
	var grabbing = $Body/Head/Grabbing.get_collider()
	var forward = $Body/Head/Forward.get_collider()
	var backward = $Body/Head/EvadeBack.get_collider()
	var front_right = $Body/Head/SeekRight.get_collider()
	var front_left = $Body/Head/SeekLeft.get_collider()
	var back_right = $Body/Head/EvadeRight.get_collider()
	var back_left = $Body/Head/EvadeLeft.get_collider()
	var right = $Body/Head/Right.get_collider()
	var left = $Body/Head/Left.get_collider()
	var motion = Vector3()
	var turn = 0.0


	if front_left != null:
		turn -= 0.5 + randf()
	elif front_right != null:
		turn += 0.5 + randf()
	
	if left != null:
		turn -= 0.3 + randf()
	elif right != null:
		turn += 0.3 + randf()
	
	if back_left != null:
		turn -= 0.2 + randf()
	elif back_right != null:
		turn += 0.2 + randf()

	if grabbing == null:
		if forward == null:
			motion = get_transform().basis.z.normalized() * (-speed * delta)
			set_state(1, 2.5)
			if backward == null:
				set_state(1, 0.75+abs(turn))
				rotate_object_local(Vector3(0,1,0), turn_speed*turn * delta)
				if turn > -0.1 && turn < 0.1:
					set_state(0, 1.25)
			if backward != null:
				set_state(1, 3.75)
				motion = get_transform().basis.z.normalized() * (-speed*1.5 * delta)
				rotate_object_local(Vector3(0,1,0), turn_speed*turn * delta)
		vel = move_and_slide(motion)
	else:
		if forward != null:
			if backward == null:
				set_state(1, 0.75+abs(turn))
				rotate_object_local(Vector3(0,1,0), turn_speed*turn * delta)
			elif backward != null:
				set_state(1, 0.75+abs(turn))
				rotate_object_local(Vector3(0,1,0), turn_speed*turn * delta)
			else:
				set_state(0, 1.25)



func set_state(s, anim_speed):
	state = s
	anim.playback_speed = anim_speed



func _on_AnimationPlayer_animation_finished(_anim_name):
	if state == 0:
		anim.play("idle")
	else:
		anim.play("scurry")
