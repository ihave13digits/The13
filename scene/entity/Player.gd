extends KinematicBody

var gravity = Vector3.DOWN  # strength of gravity
var speed = 400 # movement speed
var jump_speed = 6  # jump strength
var spin = 0.1  # rotation speed
var max_pitch = 60.0
var _yaw = 0.0
var _pitch = 0.0
var velocity = Vector3.ZERO
var jump = false
var has_control = true

onready var pivot



func _ready():
	pivot = $Pivot
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func get_input():
	velocity.x = 0
	velocity.z = 0
	
	if Input.is_action_just_pressed("menu"):
		if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			has_control = false
		elif Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			has_control = true
	
	if Input.is_action_pressed("move_forward"):
		velocity += pivot.get_transform().basis.z
	elif Input.is_action_pressed("move_back"):
		velocity -= pivot.get_transform().basis.z
	if Input.is_action_pressed("strafe_right"):
		velocity -= pivot.get_transform().basis.x
	elif Input.is_action_pressed("strafe_left"):
		velocity += pivot.get_transform().basis.x

func _physics_process(delta):
	velocity += gravity
	get_input()
	if velocity.length() > 0.01:
		velocity /= velocity.length()

	var motion = velocity * (speed * delta)
	motion = move_and_slide(motion, Vector3.UP, false, 4, 0.78, true)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_yaw -= event.relative.x * spin
		_pitch += event.relative.y * spin
		if _pitch > max_pitch:
			_pitch = max_pitch
		elif _pitch < -max_pitch:
			_pitch = -max_pitch
		pivot.set_rotation(Vector3(0, deg2rad(_yaw), 0))
		pivot.rotate(pivot.get_transform().basis.x.normalized(), deg2rad(_pitch))
